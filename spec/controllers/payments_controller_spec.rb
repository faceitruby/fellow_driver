# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  context 'routing' do
    it do
      expect(post: '/api/payments').to route_to(
        controller: 'payments',
        format: :json,
        action: 'create'
      )
    end
  end

  context 'when card info' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    context 'is valid' do
      it 'register a new payment method' do
        request.headers['token'] = token

        stub_request(:post, 'https://api.stripe.com/v1/payment_methods').
          with(
            body: {
              'card': {
                'number':'4000 0000 0000 2230',
                'exp_month': '2',
                'exp_year':'2021',
                'cvc': '314'
              },
              'type': 'card'},
            ).
          to_return(status: 200, body: '{
            "id": "pm_1DcrLa2eZvKYlo2CVs0UffyP",
            "type": "card"
          }', headers:{})

          expect do
            post :create, params: {
              type: 'card',
              card: {
                number: '4000 0000 0000 2230',
                exp_month: 2,
                exp_year: 2021,
                cvc: '314'
              }
            }
          end.to change(Payment, :count).by(1)
      end
    end

    context 'is not valid' do
      it 'does not register a new payment method' do
        request.headers['token'] = token

        stub_request(:post, 'https://api.stripe.com/v1/payment_methods').
          with(
            body: {
              'card': {
                'number':'4000 00100 0000 2230',
                'exp_month': '2',
                'exp_year':'2021',
                'cvc': '314'
              },
              'type': 'card'},
            ).
          to_return(status: 200, body: '{
            "error": {
              "message": "Your card number is incorrect.",
              "type": "invalid_request_error"
            }
          }', headers:{})

        expect do
          post :create, params: {
            type: 'card',
            card: {
              number: '4000 00100 0000 2230',
              exp_month: 2,
              exp_year: 2021,
              cvc: '314'
            }
          }
        end.to change(Payment, :count).by(0)
      end
    end
  end
end
