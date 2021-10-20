# frozen_string_literal: true

module FavouriteLocations
  # Service for adding favourite address to the user
  class CreateService < ApplicationService
    # @attr_reader params [Hash]
    # - current_user: [User] current_user
    # - name [String] the name we add
    # - address [String] the address we add
    # - description [Text] the description we add

    def call
      raise ArgumentError, 'Current user is missing' unless current_user

      current_user.favourite_locations.create!(location_attributes)
    end
  end
end
