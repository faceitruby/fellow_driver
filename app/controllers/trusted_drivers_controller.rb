# frozen_string_literal: true

class TrustedDriversController < ApplicationController
  def index
    render_response(current_user.trusted_drivers.map do |trusted|
      User.find(trusted.trusted_driver_id).present.page_context
    end)
  end

  def trusted_for
    render_response(current_user.trusted_drivers.map do |trusted|
      User.find(trusted.trust_driver_id).present.page_context
    end)
  end

  def create
    result = TrustedDrivers::CreateService.perform(
      trusted_driver_request: trusted_driver_request, current_user: current_user
    )
    result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors)
  end

  def destroy
    result = TrustedDrivers::DeleteService.perform(trusted_driver: trusted_driver)
    render_success_response(result.data, :no_content)
  end

  private

  def trusted_driver_params
    params.require(:trusted_triver_request).permit(:id)
  end

  def trusted_driver_request
    TrustedDriverRequest.find(trusted_driver_params[:id])
  end

  def trusted_driver
    TrustedDriver.find(params[:id])
  end
end
