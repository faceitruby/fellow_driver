# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }

    factory :user_with_email_phone do
      email { Faker::Internet.email }
      phone { Faker::Base.numerify('###-###-####') }
    end
    factory :user_with_missing_fields_update do
      first_name { Faker::Name.first_name }
      avatar { Rack::Test::UploadedFile.new('/home/developer/avatar.svg') }
      address { Faker::Address.full_address }

      factory :correct_user_update do
        last_name { Faker::Name.last_name }
        email { Faker::Internet.email }
        phone { Faker::Base.numerify('###-###-####') }
      end
    end
  end
end
