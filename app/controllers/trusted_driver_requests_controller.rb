# frozen_string_literal: true

class TrustedDriverRequestsController < ApplicationController
  before_action :check_age

  def index
    render_response(trusted_driver_requests_list)
  end

  def create
    result = TrustedDrivers::Requests::CreateService.perform(
      trusted_driver_requests_params.merge(current_user: current_user)
    )
    render_success_response(result, :created)
  end

  def destroy
    TrustedDrivers::Requests::DeleteService.perform(
      trusted_driver_request: trusted_driver_request
    )
    render_success_response
  end

  private

  def trusted_driver_requests_params
    params.require(:trusted_driver_request).permit(:email, :phone, :facebook_uid, :family_member)
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
