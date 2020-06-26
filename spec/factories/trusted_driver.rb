# frozen_string_literal: true

FactoryBot.define do
  factory :trusted_driver do
    association :trusted_driver, factory: :user # user which will be a friend for trust_driver
    association :trust_driver, factory: :user # user which requests a friend(trusted_driver)
  end
end
