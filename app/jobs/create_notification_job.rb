class CreateNotificationJob
  @queue = :notification

  def self.perform()
    notification = Notification.find_by(subject: 'without_car')
    registration_ids = User.without_car.map { |user| user.devices.ids }
    Notifications::PushService.perform(notification: notification, registration_ids: registration_ids)

    notification = Notification.find_by(subject: 'without_trusted_drivers')
    registration_ids = User.without_trusted_drivers.map { |user| user.devices.ids }
    Notifications::PushService.perform(notification: notification, registration_ids: registration_ids)

    Rpush.push
  end
end
