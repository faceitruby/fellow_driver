# frozen_string_literal: true

FactoryBot.define do
  factory :trusted_driver do
    association :trusted_driver, factory: :user
    association :trust_driver, factory: :user
  end
end
