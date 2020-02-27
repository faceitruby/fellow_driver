# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }

    trait :email do
      email { Faker::Internet.email }
    end
    trait :phone do
      phone { Faker::Base.numerify('###-###-####') }
    end
    trait :avatar do
      avatar { Rack::Test::UploadedFile.new('/home/developer/avatar.svg') }
    end
    trait :address_first_last_names do
      address { Faker::Address.full_address }
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
    end
    trait :all_fields do
      email
      phone
      avatar
      address_first_last_names
    end
  end
end
