FactoryBot.define do
  factory :car do
    user_id { create(:correct_user_update).id }
    manufacturer { 'test_manufacturer' }
    model { 'test_model' }
    year { 2000 }
    color { '#324' }
    license_plat_number { '2342' }
    picture { Rack::Test::UploadedFile.new('spec/support/assets/test-image.jpeg', 'image/jpeg') }
  end
end
