# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: current_user.id) }
  let(:params) do
    {
        user: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            phone: Faker::Base.numerify('###-###-####'),
            email: Faker::Internet.email,
            avatar: Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']),
            address: Faker::Address.full_address,
            member_type: User.member_types.keys.sample,
            password: 'password'
        }
    }
  end

  before do
    request.headers['token'] = token
    allow(Twilio::TwilioTextMessenger).to receive(:perform)
  end

  describe 'POST#create' do
    let(:send_request) { post :create,
                              params: params.merge(current_user: current_user),
                              as: :json }

    subject { response }

    it 'creates user' do
      expect { send_request }.to change(User, :count).by(1)
    end

    context 'when invites' do
      before { send_request }

      it 'returns json' do
        expect(response.content_type).to include('application/json')
      end
      it 'invited user has the same family as inviter' do
        expect(response.parsed_body['data']['user']['family_id']).
            to eq(current_user.family_id)
      end
      it 'new user was invited by current_user' do
        expect(response.parsed_body['data']['user']['invited_by_id']).
            to eq(current_user.id)
      end
      it { expect(response).to have_http_status(:created) }
      it_behaves_like 'success action'
    end
  end

  describe 'PUT#update' do
    let(:user) { create(:user, skip_invitation: true) }
    let(:send_request) { put :update,
                             params: update_params,
                             as: :json }

    before do
      user.invite!(current_user)
      send_request
    end

    subject { response }

    context 'with correct token' do
      let(:update_params) do
        {
            user: params[:user].merge(invitation_token: user.raw_invitation_token)
        }
      end

      it 'returns json' do
        expect(response.content_type).to include('application/json')
      end
      it { expect(response).to have_http_status(:accepted) }
      it_behaves_like 'success action'
    end

    context 'with invalid token' do
      let(:update_params) do
        {
            user: params[:user].merge(invitation_token: 'some_token')
        }
      end

      it 'returns json' do
        expect(response.content_type).to include('application/json')
      end
      it { expect(response).to have_http_status(:unprocessable_entity) }
      it_behaves_like 'failure action'
    end
  end
end
