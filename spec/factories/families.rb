FactoryBot.define do
  factory :family do
    user_id { User.last.id }
    owner { 1 }
    member_type { Family.member_types.keys.sample }
  end
end
