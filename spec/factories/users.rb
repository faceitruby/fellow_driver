FactoryBot.define do
  factory :user do
    password { 'password' }

    trait :correct_user_update do
      email { Faker::Internet.email }
      phone { Faker::Base.numerify('###-###-####') }
    end
  end
end
