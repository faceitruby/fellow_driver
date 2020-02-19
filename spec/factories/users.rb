FactoryBot.define do
  factory :user do
    password { 'password' }

    factory :user_with_email_phone do
      email { 'user@example.com' }
      phone { '123-456-7890' }
    end

    factory :correct_user_update do
      email { 'user@example.com' }
      phone { '123-456-7890' }
    end
  end
end
