# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'facebook_friends_controller' do
  it { expect(response.content_type).to include('application/json') }
  it { expect(response).to have_http_status(status) }
  it { expect(response.parsed_body['success']).to be true }
  it { expect(response.parsed_body['facebook_friends']).to be_instance_of Array }
end

RSpec.describe FacebookFriendsController, type: :controller do
  describe 'routing' do
    it do
      expect(get: '/api/facebook_friends').to route_to(controller: 'facebook_friends', action: 'index', format: :json)
    end
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
    let(:headers) do
      {
        token: token,
        'access-token-fb': access_token,
        near: near
      }
    end

    before do
      allow(TrustedDrivers::Facebook::FetchFriendsService).to receive(:perform)
        .with(facebook_friends_params)
        .and_return(service_response)
    end

    context 'when friends found' do
      let(:status) { :ok }
      let(:service_response) { [user_friend] }

      before do
        request.headers.merge! headers
        send_request
      end

      it { expect(response.parsed_body['facebook_friends'].size).to be_positive }
      it_behaves_like 'facebook_friends_controller'
    end

    context 'when friends not found' do
      let(:status) { :ok }
      let(:service_response) { [] }

      before do
        request.headers.merge! headers
        send_request
      end

      it { expect(response.parsed_body['facebook_friends'].size).to be_zero }
      it_behaves_like 'facebook_friends_controller'
    end

    context 'when missing' do
      context 'header \'access-token-fb\'' do
        let!(:headers) { super().except :'access-token-fb' }
        let(:message) { 'Facebook access token is missing' }
        let(:service_response) { [user_friend] }

        before do
          request.headers.merge! headers
          send_request
        end

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

        before do
          request.headers.merge! headers
          send_request
        end

        it_behaves_like 'facebook_friends_controller'
      end

      context 'token' do
        let(:token) { nil }
        let(:service_response) { nil }

        it_behaves_like 'with missing token'
      end
    end
  end
end
