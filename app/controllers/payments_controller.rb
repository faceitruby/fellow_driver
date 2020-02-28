# frozen_string_literal: true

# Write payment method to DB
class PaymentsController < ApplicationController
  def create
    result = Payments::PreparePaymentService.perform(params.merge(user: current_user))
    result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors)
  end
end
