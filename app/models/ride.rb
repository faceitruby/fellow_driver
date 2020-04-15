# frozen_string_literal: true

class Ride < ApplicationRecord
  has_one :ride_messages

  enum status: { requested: 0, complete: 1 }
  
  validates :passengers, presence: true
  validates :start_address, presence: true
  validates :end_address, presence: true
  validates :payment, presence: true
  validates :date, presence: true
  validates :message, presence: true
end
