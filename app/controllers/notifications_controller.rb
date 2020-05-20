# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    render_response(Notification.all.map { |notification| notification.present.notification_page_context })
  end

  def create
    render_success_response(Notifications::CreateService.perform(notification_params.merge(user: current_user)), :created)
  end

  def destroy
    render_success_response(Notifications::DestroyService.perform(notification: notification), :no_content)
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :type)
  end

  def notification
    Notification.find(params[:id])
  end
end
