# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::RidesController, type: :controller do
  describe 'routing' do
    it 'RideController have index method' do
      expect(get: '/api/rides')
        .to route_to(controller: 'rides/rides', format: :json, action: 'index')
    end

    it 'RideController have show method' do
      expect(get: '/api/rides/1')
        .to route_to(controller: 'rides/rides', id: '1', format: :json, action: 'show')
    end

    it 'RideController have create method' do
      expect(post: '/api/rides')
        .to route_to(controller: 'rides/rides', format: :json, action: 'create')
    end

    it 'RideController have destroy method' do
      expect(delete: '/api/rides/1')
        .to route_to(controller: 'rides/rides', id: '1', format: :json, action: 'destroy')
    end
  end

  describe 'GET#index' do
    let(:send_request) { get :index }
    let(:current_user) { create(:user) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
    let(:field_name) { 'rides' }

    before do |test|
      request.headers.merge! headers
      send_request unless test.metadata[:skip_send_request]
    end

    context 'when user has requests', :skip_send_request do
      let!(:ride) { create(:ride, requestor: current_user) }

      before { send_request }

      include_examples 'success response'
    end

    context 'when user does not have requests' do
      subject { response }

      include_examples 'success response' do
        let(:enable_field_name_test) { false }
      end
      it { expect(response[field_name]).to_not be_present }
    end

    context 'with token missing' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end

  describe 'GET#show' do
    let(:send_request) { get :show, params: { id: ride.id } }
    let(:current_user) { create(:user) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
    let(:ride) { create(:ride) }
    let(:expected_response) { { success: true }.merge(ride.present.page_context).to_json }

    before do
      request.headers.merge! headers
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:ok) }
    it 'return JSON with request info' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'POST#create' do
    let(:field_name) { 'ride' }
    let(:send_request) { post :create, params: { ride: params } }
    let(:date) { Date.tomorrow }
    let(:user) { create(:user, :trusted_driver, :payment) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }
    let(:payment) { Faker::Number.within(range: 10..100) }
    let(:addresses) { Array.new(2) { Faker::Address.full_address } }
    let(:message) { Faker::Lorem.sentence }
    let(:template_id) { create(:ride_template).id }
    let(:passengers) { [user.id] }
    let(:ride_message_attributes) do
      {
        message: message,
        ride_template_id: template_id
      }
    end
    let(:params) do
      {
        passengers: passengers,
        date: date.to_s,
        start_address: addresses[0],
        end_address: addresses[1],
        payment: payment,
        ride_message_attributes: ride_message_attributes
      }
    end

    before(:each) do |test|
      request.headers.merge! headers
      send_request unless test.metadata[:skip_send_request]
    end

    context 'with correct fields' do
      context 'with message provided' do
        let(:ride_message_attributes) { super().except :ride_template_id }

        include_examples 'success response' do
          let(:status) { :created }
        end
        it '', :skip_send_request do
          expect { send_request }.to(change(Ride, :count).by(1)
                                 .and(change(RideTemplate, :count).by(1)))
        end
      end

      context 'with ride_template_id provided' do
        let(:ride_message_attributes) { super().except :message }

        include_examples 'success response' do
          let(:status) { :created }
        end
        it '', :skip_send_request do
          expect { send_request }.to(change(Ride, :count).by(1)
                                 .and(change(RideTemplate, :count).by(1)))
        end
      end
    end

    context 'when user does not have payment' do
      let(:user) { create(:user, :trusted_driver) }

      include_examples 'failed response'
    end

    context 'when user does not have trusted_drivers' do
      let(:user) { create(:user, :payment) }

      include_examples 'failed response'
    end

    context 'with missing' do
      %i[passengers start_address end_address date payment].each do |field|
        context field.to_s do
          let(:params) { super().except field }

          include_examples 'failed response'
        end
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end

  describe 'DELETE#destroy' do
    let(:send_request) { delete :destroy, params: { id: ride.id } }
    let(:ride) { create(:ride) }
    let(:current_user) { ride.requestor }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }

    subject { response }

    before { request.headers.merge! headers }

    context 'when ride exists' do
      before { send_request }

      it { is_expected.to have_http_status(:no_content) }
    end

    context 'when ride does not exists' do
      let(:message) { 'Couldn\'t find Ride with \'id\'' }

      before do
        ride.destroy
        send_request
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(response.parsed_body['success']).to be false }
      it { expect(response.parsed_body['error']).to include message }
    end
  end
end
