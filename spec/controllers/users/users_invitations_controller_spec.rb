# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  # let(:user) { create(:user) }
  # let(:token) { JsonWebToken.encode(user_id: user.id) }
  # let(:invite_params) { { phone: '780-251-0592', member_type: 'father' } }
  # let(:invite_response) {{ success: true, data: { }, errors: nil }}

  # describe 'routing' do
  #   it { expect(post: '/api/users/invitation').to route_to(controller: 'users/invitations', format: :json, action: 'create') }
  # end

  describe 'POST#create' do
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

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      request.headers['token'] = token
      # allow(Twilio::TwilioTextMessenger).to receive(:perform)
      allow(Users::InvitationService).to receive(:perform).and_return(OpenStruct.new(success?: true,
                                                                                     data: { user: '111' },
                                                                                     errors: nil))
    end

    subject { send_request }

    xit 'returns json' do
      subject
      expect(response.content_type).to include('application/json')
    end

    context 'when invites' do
      xit 'creates user' do
        expect { subject }.to change(User, :count).by(1)
      end

      xit 'creates family' do
        expect { subject }.to change(Family, :count).by(1)
      end

      xit 'has status CREATED' do
        subject
        expect(response).to have_http_status(:created)
      end



      it '111' do
        # subject
        expect(Users::InvitationService.perform).to eq(OpenStruct)
      end
    end
  end
end
