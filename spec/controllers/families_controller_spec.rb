# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamiliesController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/families').to route_to(controller: 'families', action: 'index', format: :json) }
  end

  let(:current_user) { create(:user) }
  let(:user) { create(:user) }
  let(:family) { create(:family) }
  let(:token) { JsonWebToken.encode(user_id: current_user.id) }

  describe 'GET#index' do
    let(:send_request) { get :index }
    let(:expected_response) do
      [family.present.family_page_context].to_json
    end

    before do
      request.headers['token'] = token
      user
      family
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of members' do
      expect(response.body).to eq(expected_response)
    end
  end
end
