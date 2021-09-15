# frozen_string_literal: true

module FavouriteLocations
  # Service for user creation
  class DestroyService < ApplicationService
    # @attr_reader params [Hash]
    # - favourite_location [FavouriteLocation]
    # - current_user: [User] current_user

    def call
      raise ArgumentError, "Favourite Location not found" unless favourite_location
      raise ArgumentError, "You are not allowed to destroy this data" unless
        current_user.favourite_locations.include?(favourite_location)

      favourite_location.destroy
    end
  end
end
