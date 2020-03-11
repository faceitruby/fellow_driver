# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe 'routing' do
    it { expect(post: '/api/payments').to route_to(controller: 'payments', format: :json, action: 'create') }
  end

  describe 'POST#create' do

    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }
    let(:send_request) { post :create, params: payment_params.merge(user: user) }
    let(:payments_params) { ActionController::Parameters.new(payment_params) }
    let(:card_info) { { number: '4000 00100 0000 2230', exp_month: '2', exp_year: '2021', cvc: '314' } }
    let(:payment_params) { { type: 'card', card: card_info } }
    let(:user_payment_servise) do
      payments_params.permit(:type, card: %i[number exp_month exp_year cvc]).merge(user: user)
    end

    before do
      request.headers['token'] = token

      allow(Payments::PreparePaymentService).to receive(:perform).
        with(user_payment_servise).
        and_return(service_response)

      send_request
    end

    context 'when payment method created' do

      let(:expected_response) { { success: true, data: {user_payment: 'pm_1GIsWHDuGMiAOmnfCtEI39ME'} }.to_json }

      let(:service_response) do
        OpenStruct.new(success?: true, data: { 
          user_payment: 'pm_1GIsWHDuGMiAOmnfCtEI39ME' 
          }, errors: nil)
      end

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:created) }
      it 'is expected to return user_payment in data' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when payment method is not created' do
      let(:expected_response) { { success: false, message: 'error messages', data: nil }.to_json }
      let(:service_response) do
        OpenStruct.new('success': false,
          response: nil, errors: 'error messages'
        )
      end

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:bad_request) }
      it 'is expected to return error message' do
        expect(response.body).to eq(expected_response)
      end
    end
  end
end
