# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:family) { create(:family) }
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
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
        family_id: user.family.id,
        password: 'password',
        password_confirmation: 'password'
      }
    }
  end
  let(:update_params) do
    {
      user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        phone: Faker::Base.numerify('###-###-####'),
        email: Faker::Internet.email,
        avatar: Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']),
        address: Faker::Address.full_address,
        member_type: User.member_types.keys.sample,
        family_id: user.family.id,
        password: 'password',
        password_confirmation: 'password',
        invitation_token: invitation_token
      }
    }
  end
  let(:invitation_token) { response.parsed_body['data']['invite_token'] }
  let(:send_post_request) { post :create,
                            params: params.merge(current_user: user),
                            as: :json }
  let(:send_put_request) { put :update,
                           params: update_params.merge(current_user: user),
                           as: :json }
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    request.headers['token'] = token
    allow(Twilio::TwilioTextMessenger).to receive(:perform)
    family
    user.update_attribute('family_id', user.family.id)
  end

  describe 'POST#create' do

    subject { response }

    it 'returns json' do
      send_post_request
      expect(response.content_type).to include('application/json')
    end

    context 'when invites' do
      it 'creates user' do
        expect { send_post_request }.to change(User, :count).by(1)
      end
      it 'invited user has the same family as inviter' do
        send_post_request
        expect(response.parsed_body['data']['user']['family_id']).
            to eq(user.family_id)
      end
    end

    context 'with correct request' do
      before { send_post_request }

      it { expect(response).to have_http_status(:created) }
      it_behaves_like 'success action'
    end
  end

  describe 'PUT#update' do
    before do
      send_post_request
      send_put_request
    end

    subject { response }

    it 'returns json' do
      expect(response.content_type).to include('application/json')
    end

    context 'with correct request' do

      it { expect(response).to have_http_status(:accepted) }
      it_behaves_like 'success action'
    end
  end
end
