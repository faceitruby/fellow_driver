# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    current_user.notifications.map { |notification| notification.present.notification_page_context })
  end

  def create
    Notifications::CreateService.perform(notification_params)
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :type, :user)
  end
end
