# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamiliesController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/families').to route_to(controller: 'families', action: 'index', format: :json) }
  end

  describe 'GET#index' do
    let(:current_user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: current_user.id) }
    let(:send_request) { get :index }
    let(:expected_response) { current_user.family.present.family_page_context.to_json }

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of members' do
      expect(response.body).to eq(expected_response)
    end
  end
end
