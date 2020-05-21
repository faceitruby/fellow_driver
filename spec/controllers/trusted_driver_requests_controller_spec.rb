# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDriverRequestsController, type: :controller do
  describe 'routing' do
    it do
      expect(post: '/api/trusted_driver_requests')
        .to route_to(controller: 'trusted_driver_requests', format: :json, action: 'create')
    end

    it do
      expect(delete: '/api/trusted_driver_requests/1')
        .to route_to(controller: 'trusted_driver_requests', format: :json, action: 'destroy', id: '1')
    end

    it do
      expect(get: '/api/trusted_driver_requests')
        .to route_to(controller: 'trusted_driver_requests', format: :json, action: 'index')
    end
  end

  let(:sender) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: sender.id) }

  before { request.headers['token'] = token }

  describe 'GET#index' do
    let(:trusted_driver_request) { create(:trusted_driver_request) }
    let(:token) { JsonWebToken.encode(user_id: trusted_driver_request.receiver_id) }
    let(:send_request) { get :index }

    let(:expected_response) do
      [trusted_driver_request.present.request_page_context].to_json
    end

    context 'with token provided' do
      before { send_request }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:success) }
      it 'render JSON with list of request on trusted driver' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'with missing token' do
      let(:token) { nil }

      include_examples 'with missing token'
    end
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: request_param }

    context 'when requested' do
      let(:trusted_driver_request) { { email: Faker::Internet.email } }
      let(:request_param) { { trusted_driver_request: trusted_driver_request } }
      let(:trusted_driver_request_params) { ActionController::Parameters.new(trusted_driver_request) }
      let(:request_params) { trusted_driver_request_params.permit(:email).merge(current_user: sender) }

      context 'with valid' do
        before do
          allow(TrustedDrivers::Requests::CreateService).to receive(:perform)
            .with(request_params)
            .and_return(service_response)

          send_request
        end

        context 'email' do
          let(:service_response) { { email_message: 'email request sent' } }

          it { expect(response).to have_http_status(:created) }
          it { expect(response.parsed_body['success']).to be true }
          it { expect(response.parsed_body['email_message']).to eq service_response[:email_message] }
        end

        context 'phone' do
          let(:service_response) { { phone_message: 'phone request sent' } }

          it { expect(response).to have_http_status(:created) }
          it { expect(response.parsed_body['success']).to be true }
          it { expect(response.parsed_body['phone_message']).to eq service_response[:phone_message] }
        end

        context 'uid' do
          let(:params) { { current_user: build(:user), user_receiver: build(:user) } }
          let(:service_response) do
            {
              facebook_message: {
                'uid' => Faker::Number.number(digits: 15),
                'message' => TrustedDrivers::Messages::CreateService.perform(params)
              }
            }
          end

          it { expect(response).to have_http_status(:created) }
          it { expect(response.parsed_body['success']).to be true }
          it { expect(response.parsed_body['facebook_message']).to eq service_response[:facebook_message] }
        end
      end

      context 'when error raised' do
        let(:error) { ArgumentError }
        before do
          allow(TrustedDrivers::Requests::CreateService).to receive(:perform)
            .with(request_params)
            .and_raise(error)

          send_request
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body['success']).to be false }
        it { expect(response.parsed_body['error']).to be_present }
      end
    end

    context 'with missing token' do
      let(:token) { nil }
      let(:request_param) { nil }

      include_examples 'with missing token'
    end
  end

  describe 'delete#destroy' do
    let(:trusted_driver_request) { create(:trusted_driver_request) }
    let(:send_request) { delete :destroy, params: { id: trusted_driver_request.id } }

    let(:expected_response) { { 'success' => true } }

    context 'with token provided' do
      let(:token) { JsonWebToken.encode(user_id: trusted_driver_request.receiver_id) }

      before { send_request }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to eq(expected_response) }
    end

    context 'with token missing' do
      let(:token) { nil }

      include_examples 'with missing token'
    end
  end
end
