# frozen_string_literal: true

module Payments
  class SavePaymentService < ApplicationService
    # @attr_reader params [Hash]
    # - user: [User] Current user
    # - pm_id: [String] Payment id
    # - type: [String] Payment type


    def call
      params[:user].payments.create(payment_type: params[:type], user_payment: params[:pm_id])
    end
  end
end
