# frozen_string_literal: true

FactoryBot.define do
  factory :ride_template do
    text { Faker::Lorem.sentence }
  end
end
