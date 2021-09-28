# frozen_string_literal: true

module FavouriteLocations
  # Service for user updating
  class UpdateService < ApplicationService
    # @attr_reader params [Hash]
    # - favourite_location: [FavouriteLocation] 
    # - current_user: [User] current_user
    # - name [String] the name we add
    # - address [String] the address we add
    # - description [Text] the description we add

    def call
      raise ArgumentError, 'Favourite Location not found' unless favourite_location
      raise ArgumentError, 'You are not allowed to update this data' unless
        current_user.favourite_locations.include?(favourite_location)

      favourite_location.update!(location_attributes)
    end
  end
end
