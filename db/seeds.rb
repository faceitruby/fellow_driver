# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Notification.create(
  title: 'without_car',
  notification_type: 'Informational',
  body:'Return a favor! Add a vehicle to help out your friends on KydRides!'
)

Notification.create(
  title: 'without_friends',
  notification_type: 'Actionable',
  body:'Connect with your friends to take advantage of KydRides Trusted Driver network!'
)
