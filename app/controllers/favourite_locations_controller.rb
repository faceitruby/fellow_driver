# frozen_string_literal: true

class FavouriteLocationsController < ApplicationController
  # GET /api/favourite_locations/
  def index
    render_response(
      current_user.favourite_locations.map do |favourite_location|
        favourite_location.present.favourite_locations_page_context
      end
    )
  end

  # GET /api/favourite_locations/:id
  def show
    render_response(favourite_location.present.favourite_locations_page_context)
  end

  # POST /api/favourite_locations/
  def create
    FavouriteLocations::CreateService.perform(location_params.merge(current_user: current_user))

    render_success_response({ message: 'Successfully added to Favorites' }, :created)
  end

  # PUT /api/favourite_locations/:id
  def update
    FavouriteLocations::UpdateService.perform(location_params.merge(favourite_location: favourite_location,
                                                                    current_user: current_user))

    render_success_response({ message: 'Successfully updated' }, :ok)
  end

  # DELETE /api/favourite_locations/:id
  def destroy
    FavouriteLocations::DestroyService.perform(favourite_location: favourite_location, current_user: current_user)

    render_success_response({ message: 'Successfully deleted from Favorites' }, :no_content)
  end

  private

  def location_params
    params.require(:favourite_location).permit(:name, :address)
  end

  def favourite_location
    FavouriteLocation.find(params[:id])
  end
end
