# frozen_string_literal: true

# ApplicationService with current_user method
module FavouriteLocations
  class ApplicationService < ApplicationService
    private

    def current_user
      params[:current_user].presence
    end

    def favourite_location
      params[:favourite_location].presence
    end

    def location_attributes
      params.slice(:name, :address).presence
    end
  end
end
