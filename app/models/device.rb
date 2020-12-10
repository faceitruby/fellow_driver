# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :user

  validates_presence_of :registration_ids, :platform

  private

  def presenter_class
    DevicePresenter
  end
end
