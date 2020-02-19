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
      begin  
        response = Stripe::StripeClient.new.request do 
          Stripe::PaymentMethod.create({
            type: @params['type'],
            card: {
              number: @params['card']['number'],
              exp_month: @params['card']['exp_month'],
              exp_year: @params['card']['exp_year'],
              cvc: @params['card']['cvc']
            }
          })
        end
        OpenStruct.new(success?: true, data: { type: response[0]['type'], id: response[0]['id'] }, errors: nil)
      rescue Stripe::InvalidRequestError => e
        OpenStruct.new(success?: false, response: nil, errors: e.error.message)
      end
    end
  end
end
