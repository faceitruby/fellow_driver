# frozen_string_literal: true

module Payments
  class StripeClientService < ApplicationService
    # @attr_reader params [Hash]
    # - type: [String] paymont type
    # - card: [Hash] Contain card info
    # - - number: [String] Card number
    # - - exp_month: [Integer] Card exp_month
    # - - exp_year: [Integer] Card exp_year
    # - - cvc: [String] Card cvc

    def call
      response = stripe_payment_method
      OpenStruct.new(success?: true, data: { type: response[0]['type'], id: response[0]['id'] }, errors: nil)
    rescue Stripe::InvalidRequestError => e
      OpenStruct.new(success?: false, response: nil, errors: e.error.message)
    end

    private

    def stripe_payment_method
      stripe_client.request do
        Stripe::PaymentMethod.create({
          type: params['type'],
          card: {
            number: params['card']['number'],
            exp_month: params['card']['exp_month'],
            exp_year: params['card']['exp_year'],
            cvc: params['card']['cvc']
          }
        })
      end
    end

    def stripe_client
      Stripe.api_key = ENV['STRIPE_API_KEY']
      @stripe_client ||= Stripe::StripeClient.new
    end
  end
end
