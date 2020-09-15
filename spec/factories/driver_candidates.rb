# frozen_string_literal: true

FactoryBot.define do
  factory :driver_candidate do
    association :driver, factory: :user
    ride
    second_connection { false }
    status { :created }

    trait :second_connection do
      second_connection { true }
    end
  end
end
