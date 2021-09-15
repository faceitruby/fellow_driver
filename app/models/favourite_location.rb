# frozen_string_literal: true

# Favourite Locations for User
class FavouriteLocation < ApplicationRecord
  belongs_to :user

  validates :name, :address, presence: true, uniqueness: {
    scope: :user_id,
    message: 'is already in your Favourite Locations'
  }

  private

  def presenter_class
    FavouriteLocationPresenter
  end
end
