# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }
    email { Faker::Internet.email }
    phone { Faker::Base.numerify('###-###-####') }
  end
end
