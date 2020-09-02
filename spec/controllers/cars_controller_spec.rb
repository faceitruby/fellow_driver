# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/cars').to route_to(controller: 'cars', action: 'index', format: :json) }
    it { expect(delete: '/api/cars/1').to route_to(controller: 'cars', action: 'destroy', format: :json, id: '1') }
    it { expect(post: '/api/cars').to route_to(controller: 'cars', format: :json, action: 'create') }
    it { expect(get: '/api/cars/1').to route_to(controller: 'cars', format: :json, action: 'show', id: '1') }
    it { expect(get: '/api/cars/new').to_not route_to(controller: 'cars', action: 'new', format: :json) }
    it { expect(patch: '/api/cars/1').to_not route_to(controller: 'cars', action: 'update', format: :json, id: '1') }
    it { expect(put: '/api/cars/1').to_not route_to(controller: 'cars', action: 'update', format: :json, id: '1') }
    it { expect(get: '/api/cars/1/edit').to_not route_to(controller: 'cars', action: 'edit', format: :json, id: '1') }
  end

  let(:car) { create(:car) }
  # headers with token
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, car.user) }

  before { request.headers.merge! headers }

  describe 'GET#index' do
    let(:send_request) { get :index, format: :json }
    let(:expected_response) { [car.present.cars_page_context].to_json }

    context 'with token provided' do
      before { send_request }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:success) }
      it 'render JSON with list of car' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end

  describe 'GET#show' do
    let(:send_request) { get :show, params: { id: car.id }, format: :json }
    let(:expected_response) { car.present.cars_page_context.to_json }

    context 'with token provided' do
      before { send_request }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:success) }
      it 'return JSON with car info' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: { car: car_params }, format: :json }
    let(:car_params) { attributes_for :car }

    context 'when car' do
      context 'is saved' do
        before { send_request }

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:created) }
        it { expect(response.parsed_body['success']).to be true }
        it { expect(response.parsed_body['car']).to be_present }
      end

      context 'is not saved' do
        before do
          allow(Cars::CarCreateService).to receive(:perform).and_raise ActiveRecord::RecordInvalid
          send_request
        end

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body['success']).to be false }
        it { expect(response.parsed_body['error']).to be_present }
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end

  describe 'DELETE#destroy' do
    let(:send_request) { delete :destroy, params: { id: car.id }, format: :json }
    let(:expected_response) { { 'success' => true } }

    context 'when deletes' do
      before { send_request }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to include('application/json') }
      it 'responses with success is true' do
        expect(response.parsed_body['success']).to be true
      end
    end

    context 'when car is already deleted' do
      before do
        car.destroy
        send_request
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.content_type).to include('application/json') }
      it 'responses with success is false' do
        expect(response.parsed_body['success']).to be false
      end
      it { expect(response.parsed_body['error']).to be_present }
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end
end
