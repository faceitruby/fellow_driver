# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe 'routing' do
    it { expect(post: '/api/payments').to route_to(controller: 'payments', format: :json, action: 'create') }
  end

  describe 'POST#create' do
    let(:user) { create(:user) }
    let(:young_user) { create(:user, :less_than_15_yo) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }
    let(:send_request) { post :create, params: payment_params.merge(user: user), format: :json }
    let(:send_invalid_request) { post :create, params: payment_params.merge(user: young_user), format: :json }
    let(:payments_params) { ActionController::Parameters.new(payment_params) }
    let(:card_info) { { number: '4000 00100 0000 2230', exp_month: '2', exp_year: '2021', cvc: '314' } }
    let(:payment_params) { { type: 'card', card: card_info } }
    let(:user_payment_params) do
      payments_params.permit(:type, card: %i[number exp_month exp_year cvc]).merge(user: user)
    end

    before { request.headers.merge! headers }

    context 'when payment method created' do
      before do
        allow(Payments::PreparePaymentService).to receive(:perform)
          .with(user_payment_params)
          .and_return(service_response)

        send_request
      end

      let(:service_response) { build(:payment) }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body['success']).to be true }
      it { expect(response.parsed_body['payment']).to be_present }
    end

    context 'when payment method is not created' do
      let(:exception) { ActiveRecord::RecordInvalid }

      before do
        allow(Payments::PreparePaymentService).to receive(:perform)
          .with(user_payment_params)
          .and_raise exception

        send_request
      end
      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.parsed_body['success']).to be false }
      it { expect(response.parsed_body['error']).to be_present }
    end

    context 'when user is less than 15 year old' do
      before { send_invalid_request }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.parsed_body['success']).to be false }
      it { expect(response.parsed_body['error']).to be_present }
    end

    context 'with missing token' do
      let(:headers) { {} }

      include_examples 'with missing token'
    end
  end
end
