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

    # make user with payment
    trait :payment do
      after(:build) { |user| user.payments << FactoryBot.build(:payment, user: user) }
      after(:stub) do |user|
        user.payments.build FactoryBot.build_stubbed(:payment, user: user).attributes.symbolize_keys
      end
    end

    # TODO: CHANGE CAR TO TRUSTED_DRIVER REAL OBJECT
    # make user with trust_driver
    trait :car do
      after(:build) { |user| user.cars << FactoryBot.build(:car, user: user) }
      after(:stub) { |user| user.cars.build FactoryBot.build_stubbed(:car, user: user).attributes.symbolize_keys }
    end
  end
end
