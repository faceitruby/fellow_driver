FactoryBot.define do
  factory :member do
    factory :valid_member do
      first_name { 'John' }
      last_name { 'Doe' }
      email { 'mail@exapmle.com' }
      phone { '123-456-7890' }
      birth_day { '26.05.1984' }
      relationship { 'son' }
      user_id { User.last.id }
    end
  end
end
