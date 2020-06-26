# frozen_string_literal: true

class DevicesController < ApplicationController
  def index
    render_response(current_user.devices.map { |device| device.present.device_page_context })
  end

  def create
    result = Devices::CreateService.perform(device_params.merge(user: current_user))

    render_success_response({ device: result.present.device_page_context }, :created)
  end

  def destroy
    Devices::DestroyService.perform(device: device)

    render_success_response({ message: 'Device removed' }, :no_content)
  end

  private

  def device_params
    params.require(:device).permit(:model, :registration_ids, :platform)
  end

  def device
    Device.find(params[:id])
  end
end
