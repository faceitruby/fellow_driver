# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe 'routes' do
    it 'have notifications create route' do
      expect(post: '/api/notifications')
        .to route_to(controller: 'notifications', format: :json, action: 'create')
    end

    it 'have notifications destroy route' do
      expect(delete: '/api/notifications/1')
        .to route_to(controller: 'notifications', format: :json, action: 'destroy', id: '1')
    end

    it 'have notifications index route' do
      expect(get: '/api/notifications')
        .to route_to(controller: 'notifications', format: :json, action: 'index')
    end
  end

  describe 'GET#index' do
    let!(:notification) { create(:notification) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, create(:user)) }
    let(:send_request) { get :index }
    let(:expected_response) { Notification.all.map { |n| n.present.notification_page_context }.to_json }

    before do
      request.headers.merge! headers
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it { expect(response.body).to eq(expected_response) }
  end

  describe 'POST#create' do
    let(:current_user) { create(:user) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
    let(:params) do
      {
        notification: {
          title: Faker::Lorem.sentence(word_count: 1),
          body: Faker::Lorem.sentence,
          type: Faker::Lorem.sentence(word_count: 1),
          subject: Faker::Lorem.sentence(word_count: 1)
        }
      }
    end
    let(:send_request) { post :create, params: params }

    before do
      request.headers.merge! headers
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:created) }
  end

  describe 'DELETE#destroy' do
    let(:notification) { create(:notification) }
    let(:send_request) { delete :destroy, params: { id: notification.id } }
    let(:user) { create(:user) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

    before do
      request.headers.merge! headers
      send_request
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
