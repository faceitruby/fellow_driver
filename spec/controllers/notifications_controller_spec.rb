# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe 'routes' do
    it do
    expect(post: '/api/notifications')
        .to route_to(controller: 'notifications', format: :json, action: 'create')
    end

    it do
    expect(delete: '/api/notifications/1')
        .to route_to(controller: 'notifications', format: :json, action: 'destroy', id: '1')
    end

    it do
    expect(get: '/api/notifications')
        .to route_to(controller: 'notifications', format: :json, action: 'index')
    end
  end

  describe 'GET#index' do
    let(:notification) { create(:notification) }
    let(:token) { JsonWebToken.encode(user_id: notification.user.id) }
    let(:send_request) { get :index }
    let(:expected_response) { [notification].to_json }
    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    xit {expect(response.body).to eq(expected_response)}
  end

  describe 'POST#create' do
    let(:current_user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: current_user.id) }
    let(:params) do
      {
        notification: {
          title: Faker::Lorem.sentence(word_count: 1),
          body: Faker::Lorem.sentence,
          type: Faker::Lorem.sentence(word_count: 1),
          user: current_user
        }
      }
    end
    let(:send_request) { post :create, params: params }

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:created) }
  end

  describe 'DELETE#destroy' do
    let(:notification) { create(:notification) }
    let(:send_request) { delete :destroy, params: { id: notification.id } }
    let(:token) { JsonWebToken.encode(user_id: notification.user.id) }
    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
