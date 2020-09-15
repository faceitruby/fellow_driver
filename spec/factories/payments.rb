# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    user
    payment_type { 'card' }
    user_payment { Faker::Lorem.sentence }
  end
end
