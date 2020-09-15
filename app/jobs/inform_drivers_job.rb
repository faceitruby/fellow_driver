# frozen_string_literal: true

class InformDriverJob
  @queue = :drivers

  def self.perform(message, driver_id)
    send_notification(message, driver_id)
  end

  def self.send_notification(message, driver_id)
    notification = Notifications::CreateService.perform(
      title: 'new ride request',
      notification_type: 'Actionable',
      body: message,
      status: true
    )
    Notifications::PushService.perform(
      notification: notification,
      registration_ids: driver_id
    )
  end
end
