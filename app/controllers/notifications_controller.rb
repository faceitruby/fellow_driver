# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    render_response(Notification.all.map { |notification| notification.present.notification_page_context })
  end

  def create
    result = Notifications::CreateService.perform(notification_params.merge(user: current_user))

    render_success_response({ notification: result.present.notification_page_context }, :created)
  end

  def destroy
    Notifications::DestroyService.perform(notification: notification)

    render_success_response({ message: 'Device removed' }, :no_content)
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :type)
  end

  def notification
    Notification.find(params[:id])
  end
end
