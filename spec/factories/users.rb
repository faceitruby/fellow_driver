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

    factory :user_with_invite do
      invitation_token { 'a90c8e9dc410c770afb6dada52fd9abfd646f70b675589bc5fb7a6e5a3dfe4a0' }
    end

    trait :create do
      avatar { nil }
      address { nil }
      first_name { nil }
      last_name { nil }
    end
  end
end
