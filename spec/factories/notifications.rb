FactoryBot.define do
  factory :notification do
    title { Faker::ChuckNorris.fact }
    body { Faker::Lorem.sentence }
    type { Faker::Lorem.sentence(word_count: 1) }
    status { false }
    user { nil }
  end
end
