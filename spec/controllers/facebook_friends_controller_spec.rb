# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'facebook_friends_controller' do
  it { expect(response.content_type).to include('application/json') }
  it { expect(response).to have_http_status(status) }
  it 'render JSON with list of trusted drivers' do
    expect(response.body).to eq(expected_response)
  end
end

RSpec.describe FacebookFriendsController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/facebook_friends').to route_to(controller: 'facebook_friends', action: 'index', format: :json ) }
  end

  describe 'GET#index' do
    let(:send_request) { get :index }
    let(:token) { JsonWebToken.encode(user_id: current_user.id) }
    let(:near) { true }
    let(:access_token) { 'access_token' }
    let(:current_user) { create(:user, :facebook) }
    let(:user_friend) { create(:user, :facebook) }
    let(:facebook_friends_params) do
      {
        current_user: current_user,
        access_token: access_token,
        near: near
      }
    end

    before do
      allow(TrustedDrivers::FacebookFriendsListService).to receive(:perform)
      .with(facebook_friends_params)
      .and_return(service_response)

      request.headers['token'] = token
      request.headers['facebooktoken'] = access_token
      request.headers['near'] = near

      send_request
    end

    context 'when success found friends' do
      let(:status) { :success }
      let(:expected_response) { service_response.data.to_json }
      let(:service_response) do
        OpenStruct.new(
          success?: true,
          data: [
            user_friend
          ],
          errors: nil
        )
      end

      it_behaves_like 'facebook_friends_controller'
    end

    context 'when friends not found' do
      let(:status) { :bad_request }

      let(:service_response) do
        OpenStruct.new(
          success?: false,
          data: 'nil',
          errors: 'some error message'
        )
      end

      let(:expected_response) do
        {
          success: false,
          message: service_response.errors,
          data: nil
        }.to_json
      end

      it_behaves_like 'facebook_friends_controller'
    end
  end
end
