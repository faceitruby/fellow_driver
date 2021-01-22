# frozen_string_literal: true

FactoryBot.define do
  factory :family_connection do
    association :requestor_user, factory: :user
    association :receiver_user, factory: :user
    member_type { User.member_types.keys.first(4).sample }
  end
end
