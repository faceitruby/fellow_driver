class Family < ApplicationRecord
  has_many :users

  enum member_type: {
      mother:   'mother',
      father:   'father',
      son:      'son',
      daughter: 'daughter'
  }

  validates :member_type, inclusion: {in: member_type.keys},
            message: "%{value} is not a member type"
end
