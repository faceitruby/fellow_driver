# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/cars').to route_to(controller: 'cars', action: 'index', format: :json ) }
    it { expect(delete: '/api/cars//1').to route_to(controller: 'cars', action: 'destroy', format: :json, id: '1') }
    it { expect(post: '/api/cars').to route_to(controller: 'cars', format: :json, action: 'create') }
    it { expect(get: '/api/cars/1').to route_to(controller: 'cars', format: :json, action: 'show', id: '1') }
    it { expect(get: '/api/cars/new').to_not route_to(controller: 'cars', action: 'new', format: :json) }
    it { expect(patch: '/api/cars/1').to_not route_to(controller: 'cars', action: 'update', format: :json,id: '1') }
    it { expect(put: '/api/cars/1').to_not route_to(controller: 'cars', action: 'update', format: :json, id: '1') }
    it { expect(get: '/api/cars/1/edit').to_not route_to(controller: 'cars', action: 'edit', format: :json, id: '1') }
  end


  let(:car) { create(:car) }
  let(:token) { JsonWebToken.encode(user_id: car.user.id) }

  describe 'GET#index' do
    let(:send_request) { get :index }
    let(:expected_response) do
      [car.present.cars_page_context].to_json
    end

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of car' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'GET#show' do
    let(:send_request) { get :show, params: { id: car.id } }
    let(:expected_response) do
      car.present.cars_page_context.to_json
    end

    before do
      request.headers['token'] = token
      send_request
    end
    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'return JSON with car info' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: { car: car_params } }
    let(:car_params) do
      {
        manufacturer: Faker::Vehicle.manufacture,
        model: Faker::Vehicle.model,
        year:  Faker::Number.number(digits: 4),
        color:  Faker::Color.hex_color,
        license_plat_number:  Faker::Number.number(digits: 4),
      }
    end

    context 'when car' do
      context 'is saved' do
        let(:car_params) do
            super().merge(picture: Rack::Test::UploadedFile.new('spec/support/assets/test-image.jpeg', 'image/jpeg'))
        end

        before do
          request.headers['token'] = token
          send_request
        end

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:created) }
      end

      context 'is not saved' do
        before do
          request.headers['token'] = token
          send_request
        end

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:bad_request) }
      end
    end
  end

  describe 'DELETE#destroy' do
    let(:send_request) { delete :destroy, params: { id: car.id } }
    let(:expected_response) do
      { success: true, data: { message: 'deleted' } }.to_json
    end

    before do
      request.headers['token'] = token
    end

    it { expect(send_request).to have_http_status(:no_content) }
    it 'is expected to returns hash with status && message' do
      expect(send_request.body).to eq(expected_response)
    end
  end
end
