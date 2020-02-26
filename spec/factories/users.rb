# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    factory :valid_user do
      email { 'mail@exapmle.com' }
    end
  end
end
