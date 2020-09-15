# frozen_string_literal: true

class NotificateDriversJob
  @queue = :drivers

  def self.perform(drivers)
    send_notification(drivers)
  end

  def self.send_notification(drivers)
    notification = Notifications::CreateService.perform(
      title: 'new ride request',
      notification_type: 'Actionable',
      body: 'New ride request found. Wand to apply?',
      status: true
    )
    Notifications::PushService.perform(
      notification: notification,
      registration_ids: drivers.map(&:id)
    )
  end
end
