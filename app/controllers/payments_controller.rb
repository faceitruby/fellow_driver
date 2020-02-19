class PaymentsController < ApplicationController
  def create
    result = Payments::PreparePaymentService.perform({ params: params, token: request.headers['token'] })
    result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors)
  end
end
