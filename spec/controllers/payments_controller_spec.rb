# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe 'Routing' do
    it do
      expect(post: '/api/payments').to route_to(
        controller: 'payments',
        format: :json,
        action: 'create'
      )
    end
  end

  describe 'POST#create' do

    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    context 'when payment method created' do
      let(:prepare_service_response) do
        OpenStruct.new(success?: true, data: { 
          "user_payment": "pm_1GIsWHDuGMiAOmnfCtEI39ME" 
          }, errors: nil)
      end

      it { expect(prepare_request.content_type).to include('application/json') }
      it { expect(prepare_request).to have_http_status(:created) }

      it 'is expected to return user_payment in data' do
        prepare_request
        expected_response = '{"success":true,"data":{"user_payment":"pm_1GIsWHDuGMiAOmnfCtEI39ME"}}'
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when payment method is not created' do
      let(:prepare_service_response) do
        OpenStruct.new('success': false,
          response: nil, errors: 'error messages'
        )
      end

      it { expect(prepare_request.content_type).to include('application/json') }
      it { expect(prepare_request).to have_http_status(:bad_request) }
      it 'is expected to return error message' do
        prepare_request
        expected_response = '{"success":false,"message":"error messages","data":null}'
        expect(response.body).to eq(expected_response)
      end
    end
  end
end

def prepare_request
  request.headers['token'] = token
  allow(Payments::PreparePaymentService).to receive(:perform).and_return(prepare_service_response)
  post :create
end
