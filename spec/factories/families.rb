# frozen_string_literal: true

FactoryBot.define do
  factory :family do
    user_id { User.last.id }
  end
end
