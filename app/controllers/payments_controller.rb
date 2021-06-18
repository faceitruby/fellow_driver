# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :check_age

  def create_customer
    Payments::Customers::CreateService.perform(customer_params.merge(user: current_user))

    render_success_response(nil, :created)
  end

  def create_charge
    Payments::Charges::CreateService.perform(charge_params.merge(user: current_user))

    render_success_response(nil, :created)
  end

  private

  def customer_params
    params.permit(:stripeToken)
  end

  def charge_params
    params.permit(:amount)
  end
end
