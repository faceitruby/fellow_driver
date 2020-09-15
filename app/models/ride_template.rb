# frozen_string_literal: true

class RideTemplate < ApplicationRecord
  # TODO: COPY TEMPLATE AS CUSTOM MESSAGE ON TEMPLATE DELETE
  has_many :messages, class_name: 'RideMessage', dependent: :nullify

  validates :text, presence: true, uniqueness: true

  private

  def presenter_class
    RideTemplatePresenter
  end
end
