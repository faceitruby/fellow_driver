# frozen_string_literal: true

# Write payment method to DB
class PaymentsController < ApplicationController
  def create
    result = Payments::PreparePaymentService.perform(payment_params.merge(user: current_user))

    render_success_response({ payment: result }, :created)
  end

  private

  def payment_params
    params.permit(:type, card: %i[number exp_month exp_year cvc])
  end
end
