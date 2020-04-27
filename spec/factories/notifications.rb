FactoryBot.define do
  factory :notification do
    title { Faker::Lorem.sentence(word_count: 3) }
    body { Faker::Lorem.sentence }
    notification_type { Faker::Lorem.sentence(word_count: 1) }
    status { true }
    user
  end
end
