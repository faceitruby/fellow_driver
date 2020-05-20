# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    user
    registration_ids { Faker::Lorem.sentence(word_count: 1) }
    platform { Faker::Lorem.sentence(word_count: 1) }
  end
end
