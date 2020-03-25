FactoryBot.define do
  factory :family do
    user_id { User.last.id }
    owner { User.first.id }
    member_type { Family.member_types.keys.sample }
  end
end
