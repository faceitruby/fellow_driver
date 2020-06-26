# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDriversController, type: :controller do
  describe 'routing' do
    it do
      expect(post: '/api/trusted_drivers')
        .to route_to(controller: 'trusted_drivers', format: :json, action: 'create')
    end
    it do
      expect(delete: '/api/trusted_drivers/1')
        .to route_to(controller: 'trusted_drivers', format: :json, action: 'destroy', id: '1')
    end

    it do
      expect(get: '/api/trusted_drivers')
        .to route_to(controller: 'trusted_drivers', format: :json, action: 'index')
    end

    it do
      expect(get: '/api/trusted_drivers/trusted_for')
        .to route_to(controller: 'trusted_drivers', format: :json, action: 'trusted_for')
    end
  end

  describe 'GET#index' do
    subject { create(:trusted_driver) }
    let(:send_request) { get :index, params: { format: JSON } }
    let(:token) { JsonWebToken.encode(user_id: subject.trust_driver_id) }

    let(:expected_response) do
      [subject.trusted_driver.present.page_context].to_json
    end

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of trusted drivers' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'GET#trusted_for' do
    subject { create(:trusted_driver) }
    let(:send_request) { get :trusted_for }
    let(:token) { JsonWebToken.encode(user_id: subject.trust_driver_id) }
    let(:expected_response) do
      [subject.trust_driver.present.page_context].to_json
    end

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of trusted drivers' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: { trusted_driver_request: { id: trusted_driver_request.id } } }
    let(:token) { JsonWebToken.encode(user_id: current_user.id) }
    let(:trusted_driver_request) { create(:trusted_driver_request) }

    before { request.headers['token'] = token }

    context 'trusted driver created' do
      let(:current_user) { trusted_driver_request.receiver }
      let(:status) { true }
      subject { response.parsed_body['trusted_driver'] }

      before { send_request }

      it { expect(response).to have_http_status(:created) }
      it { expect(response.content_type).to include('application/json') }
      it 'is expected success to be true' do
        expect(response.parsed_body['success']).to be true
      end
      it 'is expected id to be present' do
        expect(subject['id']).to be_present
      end
      it 'is expected trusted_driver.id to eq receiver.id' do
        expect(subject['trusted_driver_id']).to eq trusted_driver_request.receiver.id
      end
      it 'is expected trust_driver.id to eq requestor.id' do
        expect(subject['trust_driver_id']).to eq trusted_driver_request.requestor.id
      end
      it { expect { send_request }.to_not raise_error }
    end

    context 'when was raised' do
      let(:error) { ArgumentError }
      let(:current_user) { trusted_driver_request.receiver }
      let(:status) { false }

      context 'ArgumentError with message Receiver is not current user' do
        let(:message) { 'Receiver is not current user' }

        before do
          allow(TrustedDrivers::CreateService).to receive(:perform).and_raise(error, message)
          send_request
        end

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body['success']).to be false }
        it { expect(response.parsed_body['error']).to include message }
      end

      context 'ArgumentError with message Requestor and receiver must exist' do
        let(:message) { 'Requestor and receiver must exist' }

        before do
          allow(TrustedDrivers::CreateService).to receive(:perform).and_raise(error, message)
          send_request
        end

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body['success']).to be false }
        it { expect(response.parsed_body['error']).to include message }
      end

      context 'ArgumentError with message Current_user is missing' do
        let(:message) { 'Current_user is missing' }
        let(:error) { ArgumentError }

        before do
          allow_any_instance_of(TrustedDrivers::CreateService).to receive(:create_trusted_driver)
            .and_raise(error, message)
          send_request
        end

        it { expect(response.content_type).to include('application/json') }
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body['success']).to be false }
        it { expect(response.parsed_body['error']).to include message }
      end
    end
  end

  describe 'delete#destroy' do
    let(:trusted_driver) { create(:trusted_driver) }
    let(:send_request) { delete :destroy, params: { id: trusted_driver.id } }
    let(:token) { JsonWebToken.encode(user_id: trusted_driver.trust_driver_id) }

    before { request.headers['token'] = token }

    context 'when trusted_driver exists' do
      let(:expected_response) { { success: true }.to_json }

      before { send_request }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body['success']).to be true }
    end
    context 'when trusted_driver is already deleted' do
      let(:message) { 'Couldn\'t find TrustedDriver' }

      before do
        trusted_driver.destroy
        send_request
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.parsed_body['success']).to be false }
      it 'error includes "Couldn\'t find TrustedDriver"' do
        expect(response.parsed_body['error']).to include message
      end
    end
  end
end
