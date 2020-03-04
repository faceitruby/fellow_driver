# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  context 'routing' do
    it do
      expect(get: '/api/brands').to route_to(
        controller: 'vehicles',
        action: 'brands',
        format: :json
      )
    end

    it do
      expect(get: '/api/models/test').to route_to(
        controller: 'vehicles',
        action: 'models',
        format: :json,
        brand: 'test'
      )
    end
  end

  context 'GET#brands' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    let(:brands_response) do
      %w[Tesla Jaguar]
    end

    it { expect(brands_reques.content_type).to include('application/json') }
    it { expect(brands_reques).to have_http_status(:success) }

    it 'is expected to return brands names' do
      expected_response = '["Tesla","Jaguar"]'
      expect(brands_reques.body).to eq(expected_response)
    end
  end

  context 'GET#models' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    let(:models_response) do
      %w[TT A4 S4]
    end

    it { expect(models_request.content_type).to include('application/json') }
    it { expect(models_request).to have_http_status(:success) }

    it 'is expected to return brands names' do
      expected_response = '["TT","A4","S4"]'
      expect(models_request.body).to eq(expected_response)
    end
  end
end

def brands_reques
  request.headers['token'] = token
  allow(Vehicles::BrandListService).to receive(:perform).and_return(brands_response)
  get :brands
end

def models_request
  request.headers['token'] = token
  allow(Vehicles::ModelListService).to receive(:perform).and_return(models_response)
  get :models, params: { brand: 'Audi' }
end
