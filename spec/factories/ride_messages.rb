# frozen_string_literal: true

FactoryBot.define do
  factory :ride_message do
    template { nil }
    message { Faker::Lorem.sentence }
    ride

    trait :template do
      template factory: :ride_template
      message { nil }
    end
  end
end
