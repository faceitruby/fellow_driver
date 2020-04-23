# frozen_string_literal: true

class Family < ApplicationRecord
  has_many :users

  def presenter_class
    FamilyPresenter
  end
end
