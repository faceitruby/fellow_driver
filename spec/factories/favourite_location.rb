# frozen_string_literal: true

FactoryBot.define do
  factory :favourite_location do
    user
    name { Faker::Address.community }
    address { Faker::Address.full_address }
    description { Faker::Lorem.sentence }
  end
end
