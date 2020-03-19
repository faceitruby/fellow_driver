# frozen_string_literal: true

class TrustedDriverRequestsController < ApplicationController
  def index
    render_response(trusted_driver_requests_list)
  end

  def create
    result = TrustedDrivers::Requests::CreateService.perform(trusted_driver_requests_params.merge({ current_user: current_user }))
    result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors)
  end

  def destroy
    render_success_response(TrustedDrivers::Requests::DeleteService.perform(trusted_driver_request).data, :no_content)
  end

  private

  def trusted_driver_requests_params
    params.require(:trusted_driver_request).permit(:email, :phone, :facebook_uid)
  end

  def trusted_driver_request
    TrustedDriverRequest.find(params[:id])
  end

  def trusted_driver_requests_list
    current_user.trusted_driver_requests_as_receiver.map do |request|
      request.present.request_page_context
    end
  end
end
