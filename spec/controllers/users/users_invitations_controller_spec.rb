# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:params) do
    {
        "first_name": "Sergey",
        "last_name": "Magas",
        "phone": "780-251-0292",
        "member_type": "father"
    }
  end
  let(:send_request) { post :create, params: params.merge(user: user), as: :json }

  describe 'POST#create' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      request.headers['token'] = token
      allow(Twilio::TwilioTextMessenger).to receive(:perform)
    end

    subject { send_request }

    it 'returns json' do
      subject
      expect(response.content_type).to include('application/json')
    end

    context 'when invites' do
      it 'creates user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'creates family' do
        expect { subject }.to change(Family, :count).by(1)
      end

      it 'has status CREATED' do
        subject
        expect(response).to have_http_status(:created)
      end

      context '' do
        before {send_request}
        subject {response}
        it_behaves_like 'success action'

      end

    end
  end
end
