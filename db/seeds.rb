# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

RideMessage.create(message: 'I’m looking for some help to get my relationship name from location date.
                     Any chance you could help?', kind: RideMessage.kinds[:template])
RideMessage.create(message: 'I need help picking up my relationship name from location date.
                    Can you help me out?', kind: RideMessage.kinds[:template])     
RideMessage.create(message: 'I need someone to help drive my relationship name to location on date.
                    Are you nearby by any chance?', kind: RideMessage.kinds[:template])
RideMessage.create(message: 'Could you do me a favor and pickup my relationship name from location date',
                    kind: RideMessage.kinds[:template])
  