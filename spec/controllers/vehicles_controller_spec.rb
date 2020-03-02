# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  context 'routing' do
    context 'have' do
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
  end

  context 'actions' do
    let(:user) { create(:user, :correct_user_update) }
    let(:token) { JsonWebToken.encode(user_id: user.instance_of?(String) ? user : user.id) }
    it 'return success' do
      request.headers['token'] = token
      VCR.use_cassette('get_brands') do
        get 'brands'
        expect(response).to have_http_status(200)
      end
    end

    it 'return success' do
      request.headers['token'] = token
      VCR.use_cassette('get_modelss') do
        get 'models', params: { brand: 'tesla' }
        expect(response).to have_http_status(200)
      end
    end
  end
end
