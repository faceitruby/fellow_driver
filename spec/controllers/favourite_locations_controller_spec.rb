require 'rails_helper'

RSpec.describe FavouriteLocationsController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/favourite_locations')
           .to route_to(controller: 'favourite_locations', action: 'index', format: :json) }
    it { expect(get: '/api/favourite_locations/1')
           .to route_to(controller: 'favourite_locations', action: 'show', format: :json, id: '1') }
    it { expect(post: '/api/favourite_locations')
           .to route_to(controller: 'favourite_locations', action: 'create', format: :json) }
    it { expect(put: '/api/favourite_locations/1')
           .to route_to(controller: 'favourite_locations', action: 'update', format: :json, id: '1') }
    it { expect(delete: '/api/favourite_locations/1')
           .to route_to(controller: 'favourite_locations', action: 'destroy', format: :json, id: '1') }
  end

  let!(:favourite_location) { create(:favourite_location, user: current_user) }
  let(:current_user) { create(:user) }
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }

  before { request.headers.merge! headers }

  describe 'GET#index' do
    let(:send_request) { get :index, format: :json }
    let(:expected_response) { current_user.favourite_locations.map do |favourite_location|
      favourite_location.present.favourite_locations_page_context
    end.to_json }

    context 'with token provided' do
      before { send_request }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:success) }
      it 'render JSON with list of favourite places' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end

  describe 'GET#show' do
    let(:send_request) { get :show, params: { id: favourite_location.id }, format: :json }
    let(:expected_response) { favourite_location.present.favourite_locations_page_context.to_json }

    context 'with token provided' do
      before { send_request }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:success) }
      it 'return JSON with favourite place' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: { favourite_location: favourite_location.attributes }, format: :json }
    let(:expected_response) { { success: true, message: 'Successfully added to Favorites'}.to_json }
    before do
      allow(FavouriteLocations::CreateService).to receive(:perform).and_return(:favourite_location)
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:created) }
    it 'return JSON with favourite place' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'PUT#update' do
    let(:send_request) { put :update,
                             params: { id: favourite_location.id, favourite_location: favourite_location.attributes },
                             as: :json }
    let(:expected_response) { { success: true, message: 'Successfully updated'}.to_json }

    before do
      allow(FavouriteLocations::UpdateService).to receive(:perform).and_return(:favourite_location)
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:ok) }
    it 'return JSON with favourite place' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'DELETE#destroy' do
    let(:send_request) { delete :destroy,
                             params: { id: favourite_location.id },
                                format: :json }
    let(:expected_response) { { success: true, message: 'Successfully deleted from Favorites'}.to_json }

    before do
      allow(FavouriteLocations::DestroyService).to receive(:perform)
      send_request
    end

    it { expect(response).to have_http_status(:no_content) }
    it 'return JSON with favourite place' do
      expect(response.body).to eq(expected_response)
    end
  end
end
