class Family < ApplicationRecord
  has_many :users

  enum member_type: %w[mother father son daughter]

  validates :member_type, inclusion: {in: member_types.keys}

  validates :user_id, :owner, :member_type, presence: true
end
