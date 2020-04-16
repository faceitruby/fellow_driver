# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDriverRequestsController, type: :controller do
  describe 'routing' do
    it { expect(post: '/api/trusted_driver_requests').to route_to(controller: 'trusted_driver_requests',format: :json, action: 'create') }
    it { expect(delete: '/api/trusted_driver_requests/1').to route_to(controller: 'trusted_driver_requests',  format: :json, action: 'destroy', id: '1')}
    it { expect(get: '/api/trusted_driver_requests').to route_to(controller: 'trusted_driver_requests', format: :json, action: 'index')}
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

    before { send_request }

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of request on trusted driver' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: request_param }

    context 'when requested' do
      let(:trusted_driver_request) { { email: Faker::Internet.email } }
      let(:request_param) { { trusted_driver_request: trusted_driver_request } }
      let(:trusted_driver_request_params) { ActionController::Parameters.new(trusted_driver_request) }
      let(:request_params) { trusted_driver_request_params.permit(:email).merge(current_user: sender) }

      before do
        allow(TrustedDrivers::Requests::CreateService).to receive(:perform)
          .with(request_params)
          .and_return(service_response)

        send_request
      end

      context 'with valid params' do
        let(:service_response) do
          OpenStruct.new({
          success?: true,
            data: {
              message: 'success sent request'
            }
          })
        end

        let(:trusted_driver_request_response) do
          {
            success: true,
            data:service_response.data
          }.to_json
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.body).to eq(trusted_driver_request_response) }
      end

      context 'with invalid params' do

        let(:service_response) do
          OpenStruct.new({
            success?: false,
            data: nil,
            errors: 'not valid request'
          })
        end

        let(:trusted_driver_request_response) do
          {
            success: false,
            message: service_response.errors,
            data: service_response.data
          }.to_json
        end

        it { expect(response).to have_http_status(:bad_request) }
        it { expect(response.body).to eq(trusted_driver_request_response) }
      end
    end
  end

  describe 'delete#destroy' do
    let(:trusted_driver_request) { create(:trusted_driver_request) }
    let(:token) { JsonWebToken.encode(user_id: trusted_driver_request.receiver_id) }
    let(:send_request) { delete :destroy, params: { id: trusted_driver_request.id } }

    let(:expected_response) do
      { success: true, data: { message: 'deleted' } }.to_json
    end

    before { send_request }

    it { expect(response).to have_http_status(:no_content) }
    it 'is expected to returns hash with status && message' do
      expect(response.body).to eq(expected_response)
    end
  end
end
