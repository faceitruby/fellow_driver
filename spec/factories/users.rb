# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }
    email { Faker::Internet.email }
    phone { Faker::Base.numerify('###-###-####') }
    avatar { Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']) }
    address { Faker::Address.full_address }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    member_type { :owner }
    birthday { Faker::Date.birthday(min_age: 15, max_age: 65) }
    # notifications_enabled { true }
    family

    trait :create do
      avatar { nil }
      address { nil }
      first_name { nil }
      last_name { nil }
    end

    trait :facebook do
      uid { Faker::Number.number(digits: 15) }
      provider { 'facebook' }
    end

    trait :random_member do
      member_type { User.member_types.keys.first(4).sample }
    end

    trait :less_than_15_yo do
      birthday { Faker::Date.birthday(min_age: 1, max_age: 14) }
    end
  end
end
