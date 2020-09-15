# frozen_string_literal: true

class Ride < ApplicationRecord
  enum status: { created: 0, driver_found: 1, finished: 2, closed: 3 }
  belongs_to :requestor, class_name: 'User'
  has_one :message, dependent: :destroy, inverse_of: :ride, class_name: 'RideMessage'
  has_many :driver_candidates, dependent: :destroy

  validates_presence_of :passengers, :start_address, :end_address, :date, :payment
  validates :payment, numericality: { greater_than_or_equal_to: :min_payment }
  validate :passengers_exists
  accepts_nested_attributes_for :message

  private

  def presenter_class
    RidePresenter
  end

  def passengers_exists
    errors.add(:passenger, 'does not exists') unless User.where(id: passengers).size == passengers&.size
  end
end
