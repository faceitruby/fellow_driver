# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    user
    payment_type { 'card' }
    user_payment { Faker::String.random }
  end

  trait :not_allowed do
    factory :user, traits: [:young]
  end
end
