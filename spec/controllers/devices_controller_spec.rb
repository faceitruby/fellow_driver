# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  describe 'routes' do
    it 'have devices create route' do
      expect(post: '/api/devices')
        .to route_to(controller: 'devices', format: :json, action: 'create')
    end

    it 'have devices destroy route' do
      expect(delete: '/api/devices/1')
        .to route_to(controller: 'devices', format: :json, action: 'destroy', id: '1')
    end

    it 'have devices index route' do
      expect(get: '/api/devices')
        .to route_to(controller: 'devices', format: :json, action: 'index')
    end
  end

  describe 'GET#index' do
    let(:device) { create(:device) }
    let(:token) { JsonWebToken.encode(user_id: device.user.id) }
    let(:send_request) { get :index }
    let(:expected_response) { [device.present.device_page_context].to_json }
    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it { expect(response.body).to eq(expected_response) }
  end

  describe 'POST#create' do
    let(:current_user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: current_user.id) }
    let(:params) do
      {
        device: {
          registration_ids: Faker::Lorem.sentence(word_count: 1),
          platform: Faker::Lorem.sentence(word_count: 1)
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
    let(:device) { create(:device) }
    let(:params) { { id: device.id } }
    let(:token) { JsonWebToken.encode(user_id: device.user.id) }
    let(:send_request) { delete :destroy, params: params }
    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
