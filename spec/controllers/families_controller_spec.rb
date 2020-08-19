# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamiliesController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/families').to route_to(controller: 'families', action: 'index', format: :json) }
  end

  describe 'GET#index' do
    let(:current_user) { create(:user) }
    let(:send_request) { get :index, format: :json }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
    let(:expected_response) { current_user.family.present.family_page_context.to_json }

    before { request.headers.merge! headers }

    context 'with token provided' do
      before { send_request }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:success) }
      it 'render JSON with list of members' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end
end
