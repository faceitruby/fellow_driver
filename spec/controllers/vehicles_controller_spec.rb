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
end
