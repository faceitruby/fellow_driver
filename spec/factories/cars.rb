FactoryBot.define do
  factory :car do
    association :user, factory: [:user, :correct_user_update]
    manufacturer { Faker::Vehicle.manufacture }
    model { Faker::Vehicle.model }
    year { Faker::Number.number(digits: 4) }
    color { Faker::Color.hex_color }
    license_plat_number { Faker::Number.number(digits: 4) }
    picture { Rack::Test::UploadedFile.new('spec/support/assets/test-image.jpeg', 'image/jpeg') }
  end
end
