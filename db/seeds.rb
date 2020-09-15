# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
RideTemplate.create(text: 'I’m looking for some help to get relationship name from start_address date. '\
                     'Any chance you could help?')
RideTemplate.create(text: 'I need help picking up relationship name from start_address date. '\
                    'Can you help me out?')
RideTemplate.create(text: 'I need someone to help drive relationship name to end_address on date. '\
                    'Are you nearby by any chance?')
RideTemplate.create(text: 'Could you do me a favor and pickup relationship name from start_address date')

Notification.create!(
  title: 'without_car',
  notification_type: 'Informational',
  body: 'Return a favor! Add a vehicle to help out your friends on KydRides!',
  status: true
)

Notification.create!(
  title: 'without_friends',
  notification_type: 'Actionable',
  body: 'Connect with your friends to take advantage of KydRides Trusted Driver network!',
  status: true
)
