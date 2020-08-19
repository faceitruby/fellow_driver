# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

  context 'when routes exist' do
    it { expect(get: '/api/brands').to route_to(controller: 'vehicles', action: 'brands', format: :json) }
    it 'is expected have route api/models/:brand' do
      expect(get: '/api/models/test').to route_to(
        controller: 'vehicles',
        action: 'models',
        format: :json,
        brand: 'test'
      )
    end
  end

  describe 'GET#brands' do
    let(:user) { create(:user) }
    let(:brands_response) do
      %w[Tesla Jaguar]
    end

    before do
      request.headers.merge! headers
      allow(Vehicles::BrandListService).to receive(:perform).and_return(brands_response)
      get :brands
    end

    let(:expected_response) { '["Tesla","Jaguar"]' }
    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it { expect(response.body).to eq(expected_response) }
  end

  describe 'GET#models' do
    let(:user) { create(:user) }

    let(:models_response) do
      %w[TT A4 S4]
    end
    let(:expected_response) { models_response.to_json }
    let(:brand) { 'Audi' }

    before do
      request.headers.merge! headers
      allow(Vehicles::ModelListService).to receive(:perform).with(brand).and_return(models_response)
      get :models, params: { brand: brand }
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'is expected to return brands names' do
      expect(response.body).to eq(expected_response)
    end
  end
end
