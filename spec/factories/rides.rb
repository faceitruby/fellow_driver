# frozen_string_literal: true

FactoryBot.define do
  factory :ride do
    requestor factory: :user
    passengers { [requestor.id] }
    status { 0 }
    start_address { Faker::Address.full_address }
    end_address { Faker::Address.full_address }
    date { Date.tomorrow }
    payment { 1000 }

    trait :message do
      message factory: :ride_message
    end

    trait :message_with_template do
      message factory: %i[ride_message template]
    end
  end
end
