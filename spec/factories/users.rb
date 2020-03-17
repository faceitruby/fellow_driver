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

    trait :create do
      avatar { nil }
      address { nil }
      first_name { nil }
      last_name { nil }
    end
  end
end
