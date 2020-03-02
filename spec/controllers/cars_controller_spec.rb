# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  context 'routing' do
    context 'have' do
      it do
        expect(get: '/api/cars').to route_to(
          controller: 'cars',
          action: 'index',
          format: :json
        )
      end

      it do
        expect(delete: '/api/cars//1').to route_to(
          controller: 'cars',
          action: 'destroy',
          format: :json,
          id: '1'
        )
      end

      it do
        expect(post: '/api/cars').to route_to(
          controller: 'cars',
          format: :json,
          action: 'create'
        )
      end

      it do
        expect(get: '/api/cars/1').to route_to(
          controller: 'cars',
          format: :json,
          action: 'show',
          id: '1'
        )
      end
    end

    context 'not have' do
      it do
        expect(get: '/api/cars/new').to_not route_to(
          controller: 'cars',
          action: 'new',
          format: :json
        )
      end

      it do
        expect(patch: '/api/cars/1').to_not route_to(
          controller: 'cars',
          action: 'update',
          format: :json,
          id: '1'
        )
      end

      it do
        expect(put: '/api/cars/1').to_not route_to(
          controller: 'cars',
          action: 'update',
          format: :json,
          id: '1'
        )
      end

      it do
        expect(get: '/api/cars/1/edit').to_not route_to(
          controller: 'cars',
          action: 'edit',
          format: :json,
          id: '1'
        )
      end
    end
  end
end
