# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe 'routing' do
    it do
      expect(post: '/api/payments/create_customer')
        .to route_to(controller: 'payments', format: :json, action: 'create_customer')
    end

    it do
      expect(post: '/api/payments/create_charge')
        .to route_to(controller: 'payments', format: :json, action: 'create_charge')
    end
  end

  describe 'Payments' do
    let(:user) { create(:user) }
    let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

    before { request.headers.merge! headers }

    context '#create_customer' do
      context 'with valid params' do
        let(:send_request) { post :create_customer, params: { stripeToken: 'tok_visa' }, format: :json }

        before do
          allow(Payments::Customers::CreateService).to receive(:perform)

          send_request
        end

        it { expect(response.content_type).to include('application/json') }

        it { expect(response).to have_http_status(:created) }

        it { expect(response.parsed_body['success']).to be true }
      end

      context 'when exception was raised' do
        let(:send_request) { post :create_customer, params: {}, format: :json }

        before do
          allow(Payments::Customers::CreateService).to receive(:perform).and_raise(ArgumentError)

          send_request
        end

        it { expect(response.content_type).to include('application/json') }

        it { expect(response).to have_http_status(:unprocessable_entity) }

        it { expect(response.parsed_body['success']).to be false }
      end
    end

    context '#create_charge' do
      let(:send_request) { post :create_charge, params: { amount: 100 }, format: :json }

      context 'with valid params' do
        before do
          allow(Payments::Charges::CreateService).to receive(:perform)
          send_request
        end

        it { expect(response.content_type).to include('application/json') }

        it { expect(response).to have_http_status(:created) }

        it { expect(response.parsed_body['success']).to be true }
      end

      context 'when exception was raised' do
        before do
          allow(Payments::Charges::CreateService).to receive(:perform).and_raise(ArgumentError)
          send_request
        end

        it { expect(response.content_type).to include('application/json') }

        it { expect(response).to have_http_status(:unprocessable_entity) }

        it { expect(response.parsed_body['success']).to be false }
      end
    end
  end
end
