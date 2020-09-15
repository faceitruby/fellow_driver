# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FacebookFriendsController, type: :controller do
  shared_examples 'facebook_friends_controller' do
    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(status) }
    it { expect(response.parsed_body['success']).to be true }
    it { expect(response.parsed_body['facebook_friends']).to be_instance_of Array }
  end

  describe 'routing' do
    it do
      expect(get: '/api/facebook_friends').to route_to(controller: 'facebook_friends', action: 'index', format: :json)
    end
  end

  describe 'callbacks' do
    it { is_expected.to use_before_action(:authenticate_user!) }
  end

  describe 'GET#index' do
    let(:send_request) { get :index, format: :json }
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
    let(:headers) do
      {
        'access-token-fb': access_token,
        near: near
      }
    end
    let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, current_user) }

    before do
      allow(TrustedDrivers::Facebook::FetchFriendsService).to receive(:perform)
        .with(facebook_friends_params)
        .and_return(service_response)
      request.headers.merge! auth_headers
    end

    context 'when friends found' do
      let(:status) { :ok }
      let(:service_response) { [user_friend] }

      before { send_request }

      it { expect(response.parsed_body['facebook_friends'].size).to be_positive }
      it_behaves_like 'facebook_friends_controller'
    end

    context 'when friends not found' do
      let(:status) { :ok }
      let(:service_response) { [] }

      before { send_request }

      it { expect(response.parsed_body['facebook_friends'].size).to be_zero }
      it_behaves_like 'facebook_friends_controller'
    end

    context 'when missing' do
      context 'header \'access-token-fb\'' do
        let!(:headers) { super().except :'access-token-fb' }
        let(:message) { 'Facebook access token is missing' }
        let(:service_response) { [user_friend] }

        before { send_request }

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:unauthorized) }
        it { expect(response.parsed_body['success']).to be false }
        it { expect(response.parsed_body['error']).to include message }
      end

      context 'header \'near\'' do
        let!(:headers) { super().except :near }
        let(:service_response) { [user_friend] }
        let(:status) { :ok }
        let(:near) { nil }

        before { send_request }

        it_behaves_like 'facebook_friends_controller'
      end

      context 'token' do
        let(:auth_headers) { {} }
        let(:service_response) { nil }

        it_behaves_like 'with missing token'
      end
    end
  end
end
