module Payments
  class SavePaymentService < ApplicationService
    # @attr_reader params [Hash]
    # - token: [String] Current user token
    # - pm_id: [String] Payment id
    # - type: [String] Payment type


    def call
      user = Users::CurrentUserService.perform(@params[:token])
      user.payments.create(payment_type: @params[:type], user_payment: @params[:pm_id])
    end
  end
end
