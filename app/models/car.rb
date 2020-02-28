# frozen_string_literal: true

class Car < ApplicationRecord
  belongs_to :user
  has_one_attached :picture

  validates_presence_of :manufacturer, :model, :year, :picture, :color, :license_plat_number
end
