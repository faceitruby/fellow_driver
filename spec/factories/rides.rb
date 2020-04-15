FactoryBot.define do
  factory :ride do
    passengers { [association(:user).id, association(:user).id] }
    start_address { [Faker::Address.latitude, Faker::Address.longitude] }
    end_address { [Faker::Address.latitude, Faker::Address.longitude] }
    date { Time.zone.now }
    payment { Faker::Number.number(digits: 2) }
    message { Faker::Lorem.paragraph }
  end
end
