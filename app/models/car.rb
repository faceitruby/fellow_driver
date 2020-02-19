class Car < ApplicationRecord
  belongs_to :user
  has_one_attached :picture

  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :year, presence: true
  validates :picture, presence: true
  validates :color, presence: true
  validates :license_plat_number, presence: true
end
