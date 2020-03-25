# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:params) do
    {
      "first_name": Faker::Name.first_name,
      "last_name": Faker::Name.last_name,
      "phone": Faker::Base.numerify('###-###-####'),
      "email": Faker::Internet.email,
      "member_type": Family.member_types.keys.sample,
      "avatar": Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']),
      "address": Faker::Address.full_address,
      "password": "password",
      "password_confirmation": "password"
    }
  end
  let(:send_post_request) { post :create,
                            params: params.merge(user: user),
                            as: :json }
  let(:send_put_request) { put :update,
                           params: params.merge(user: user),
                           as: :json }
  let(:send_incorrect_post_request) { post :create,
                                      params: params.merge(user: user,
                                      phone: nil), as: :json }

  describe 'POST#create' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      request.headers['token'] = token
      allow(Twilio::TwilioTextMessenger).to receive(:perform)
    end

    subject { response }

    it 'returns json' do
      send_post_request
      expect(response.content_type).to include('application/json')
    end

    context 'when invites' do
      it 'creates user' do
        expect { send_post_request }.to change(User, :count).by(1)
      end

      it 'creates family' do
        expect { send_post_request }.to change(Family, :count).by(1)
      end
    end

    context 'with correct request' do
      before { send_post_request }

      it { expect(response).to have_http_status(:created) }
      it_behaves_like 'success action'
    end

    context 'with incorrect request' do
      before { send_incorrect_post_request }

      it_behaves_like 'failure action'
    end
  end

  describe 'PUT#update' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      request.headers['token'] = token
      allow(Twilio::TwilioTextMessenger).to receive(:perform)
    end

    subject { response }

    it 'returns json' do
      send_put_request
      expect(response.content_type).to include('application/json')
    end

    context 'with correct request' do
      before do
        send_post_request
        params['invitation_token'] =
            response.parsed_body['data']['invite_token']
        send_put_request
      end

      it { expect(response).to have_http_status(:accepted) }
      it_behaves_like 'success action'
    end

    context 'with incorrect request' do
      before do
        send_post_request
        send_put_request
      end

      it_behaves_like 'failure action'
    end
  end
end
