# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::CandidatesController, type: :controller do
  describe 'routes' do
    it do
      expect(get: '/api/rides/1/candidates').to route_to(controller: 'rides/candidates', format: :json,
                                                         action: 'index', id: '1')
    end
    it do
      expect(post: '/api/rides/1/accept').to route_to(controller: 'rides/candidates', format: :json,
                                                      action: 'create', id: '1')
    end
  end

  describe 'GET#index' do
    let(:user) { create :user }
    let(:driver) { create(:trusted_driver, trust_driver: user).trusted_driver }
    let(:ride) { create :ride, requestor: user }
    let(:params) { { id: ride.id } }
    let(:send_request) { get :index, params: params }
    let(:headers) {  Devise::JWT::TestHelpers.auth_headers({}, user) }
    let(:field_name) { 'candidates' }

    before do |test|
      request.headers.merge! headers
      send_request unless test.metadata[:skip_send_request]
    end

    context 'when driver candidate exists', :skip_send_request do
      let!(:driver_candidate) { create :driver_candidate, driver: user, ride: ride }

      before { send_request }

      include_examples 'success response'
    end

    context 'when driver candidate does not exist' do
      before { send_request }

      include_examples 'success response' do
        let(:enable_field_name_test) { false }
      end
      it { expect(response[field_name]).to_not be_present }
    end
  end

  describe 'POST#create' do
    let(:user) { create :user }
    let(:driver) { create(:trusted_driver, trust_driver: user).trusted_driver }
    let(:ride) { create :ride, requestor: user }
    let(:params) do
      {
        driver_id: driver.id,
        id: ride.id
      }
    end
    let(:send_request) { post :create, params: { id: ride.id } }
    let(:headers) {  Devise::JWT::TestHelpers.auth_headers({}, user) }
    let(:field_name) { 'candidate' }

    before do
      request.headers.merge! headers
      send_request
    end

    context 'when all params provided' do
      let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, driver) }

      include_examples 'success response' do
        let(:status) { :created }
      end
    end

    context 'with missing' do
      %i[driver_id ride_id].each do |field|
        context field.to_s do
          let(:params) { super().except(field) }

          include_examples 'failed response'
        end
      end
    end
  end
end
