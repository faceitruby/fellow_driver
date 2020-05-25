class NotificationsReceiversController < ApplicationController
  def create
    Notifications::SetReceivingService.perform(user: current_user, status: true)
  end

  def destroy
    Notifications::SetReceivingService.perform(user: current_user, status: false)
  end
end
