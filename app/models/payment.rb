class Payment < ApplicationRecord
  belongs_to :user

  validates :user_payment, presence: true
  validates :payment_type, presence: true
end
