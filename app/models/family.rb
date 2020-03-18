class Family < ApplicationRecord
  has_many :users

  enum member_type: [
      :mother,
      :father,
      :son,
      :daughter
  ]

  # validates :member_types, inclusion: {in: member_types.keys},
  #           message: "%{value} is not a member type"
end
