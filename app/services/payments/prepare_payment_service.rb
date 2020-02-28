# frozen_string_literal: true

module Payments
  class PreparePaymentService < ApplicationService
    # @attr_reader params [Hash]
    # - user: [User] Current user
    # - params: [Hash] Hash with paymont information:
    # - - type: [String] paymont type
    # - - card: [Hash] Contain card info
    # - - - number: [String] Card number
    # - - - exp_month: [Integer] Card exp_month
    # - - - exp_year: [Integer] Card exp_year
    # - - - cvc: [String] Card cvc

    def call
      result = Payments::StripeClientService.perform(params)
      if result.success?
        pm_info = { user: params[:user], pm_id: result.data[:id], type: result.data[:type] }
        user_payment = Payments::SavePaymentService.perform(pm_info)
        OpenStruct.new(success?: true, data: user_payment, errors: nil)
      else
        result
      end
    end
  end
end
