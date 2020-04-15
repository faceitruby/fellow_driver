# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDriversController, type: :controller do
  describe 'routing' do
    it { expect(post: '/api/trusted_drivers').to route_to(controller: 'trusted_drivers',format: :json, action: 'create') }
    it { expect(delete: '/api/trusted_drivers/1').to route_to(controller: 'trusted_drivers',  format: :json, action: 'destroy', id: '1')}
    it { expect(get: '/api/trusted_drivers').to route_to(controller: 'trusted_drivers', format: :json, action: 'index')}
    it { expect(get: '/api/trusted_drivers/trusted_for').to route_to(controller: 'trusted_drivers', format: :json, action: 'trusted_for')}
  end

  describe 'GET#index' do
    subject { create(:trusted_driver) }
    let(:send_request) { get :index, params: { format: JSON } }
    let(:token) { JsonWebToken.encode(user_id: subject.trust_driver_id) }

    let(:expected_response) do
      [subject.trusted_driver.present.page_context].to_json
    end

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of trusted drivers' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'GET#trusted_for' do
    subject { create(:trusted_driver) }
    let(:send_request) { get :trusted_for }
    let(:token) { JsonWebToken.encode(user_id: subject.trust_driver_id) }
    let(:expected_response) do
      [subject.trust_driver.present.page_context].to_json
    end

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of trusted drivers' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'POST#create' do

  end

  describe 'delete#destroy' do
    subject { create(:trusted_driver) }
    let(:send_request) { delete :destroy, params: { id: subject.id } }
    let(:token) { JsonWebToken.encode(user_id: subject.trust_driver_id) }

    let(:expected_response) do
      { success: true, data: { message: 'deleted' } }.to_json
    end

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response).to have_http_status(:no_content) }
    it 'is expected to returns hash with status && message' do
      expect(response.body).to eq(expected_response)
    end
  end
end
