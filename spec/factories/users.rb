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
    family

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

    # make user with trusted_driver
    trait :trusted_driver do
      after(:build) { |user| user.trusted_drivers << FactoryBot.build(:trusted_driver, trust_driver: user) }
      after(:stub) do |user|
        user.trusted_drivers.build(
          FactoryBot.build_stubbed(:trusted_driver, user: trust_driver).attributes.symbolize_keys
        )
      end
    end

    trait :facebook do
      uid { Faker::Number.number(digits: 15) }
      provider { 'facebook' }
    end

    trait :random_member do
      member_type { User.member_types.except(:owner).keys.sample }
    end
  end
end
