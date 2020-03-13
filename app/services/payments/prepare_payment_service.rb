# frozen_string_literal: true

module Payments
  class PreparePaymentService < Payments::ApplicationService
    # @attr_reader params [Hash]
    # - user: [User] Current user
    # - type: [String] Payment type
    # - card: [Hash] Contain card info
    # - - number: [String] Card number
    # - - exp_month: [Integer] Card exp_month
    # - - exp_year: [Integer] Card exp_year
    # - - cvc: [String] Card cvc

    def call
      result = create_payment
      if result.success?
        pm_info = { user: user, pm_id: result.data[:id], type: result.data[:type] }
        user_payment = Payments::SavePaymentService.perform(pm_info)
        OpenStruct.new(success?: true, data: user_payment, errors: nil)
      else
        result
      end
    end

    private

    def create_payment
      Payments::StripeClientService.perform(params)
    end
  end
end
