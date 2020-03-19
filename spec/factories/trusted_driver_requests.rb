# frozen_string_literal: true

FactoryBot.define do
  factory :trusted_driver_request do
    association :receiver, factory: :user
    association :requestor, factory: :user
  end
end