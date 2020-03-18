# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:invite_params) { { phone: '780-251-0592', member_type: 'father' } }
  let(:invite_response) {{ success: true, data: { }, errors: nil }}

  # describe 'routing' do
  #   it { expect(post: '/api/users/invitation').to route_to(controller: 'users/invitations', format: :json, action: 'create') }
  # end

  describe '' do
    it '' do
      request.headers['token'] = token
      allow(Users::InvitationService).to receive(:perform).and_return(invite_response)
      subject.create
      expect(response.content_type).to include('application/json')
      # it { expect(response).to have_http_status(:created) }
    end
  end


  # describe '' do
  #   let(:_user) { create(:user) }
  #   let(:token) { JsonWebToken.encode(user_id: _user.id) }
  #   let(:send_request) { post :create, params: invite_params.merge(user: _user) }
  #   let(:invite_params) { { phone: '780-251-0592', member_type: 'father' } }
  #   let(:invite__params) { ActionController::Parameters.new(invite_params) }
  #   let(:invite_response)  do
  #     OpenStruct.new(success?: true, data: {
  #       user: { 'phone': '780-251-0592' }
  #     }, errors: nil)
  #   end
  #   let(:user_invite_servise) do
  #     invite__params.permit(:email, :phone, :member_type, :skip_invitation).merge(user: _user)
  #   end
  #   before do
  #     request.headers['token'] = token
  #     allow(Users::InvitationService).to receive(:perform).with(invite_params).and_return(invite_response)
  #     pp invite__params
  #     send_request
  #   end
  #
  #   it { expect(response).to have_http_status(:ok) }
  #   it 'is expected to return user in data' do
  #     expect(response.body).to eq(invite_response)
  #   end
  # end
end
