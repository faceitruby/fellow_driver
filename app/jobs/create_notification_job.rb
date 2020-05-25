class SendNotificationsJob
  @queue = :notification

  def self.perform
    write_notifications('without_car', User.without_car)
    write_notifications('without_trusted_drivers', User.without_trusted_drivers)
    # write_notifications(subject: 'without_payments', receivers: User.without_payments)

    Rpush.push
  end

  private

  def self.write_notifications(subject, receivers)
    notification = Notification.find_by(subject: subject)
    receivers_notifications = receivers.includes(:devices).select do |user|
      user.devices.ids if user.notifications_enabled
    end
    registration_ids = receivers_notifications.map { |receiver| receiver.devices.map { |ids| ids.registration_ids } }
    Notifications::PushService.perform(notification: notification, registration_ids: registration_ids.flatten )
  end
end
