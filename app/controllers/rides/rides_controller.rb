# frozen_string_literal: true

module Rides
  class RidesController < ApplicationController
    def index
      render_success_response(
        rides: Rides::FetchService.perform(user: current_user)&.map do |request|
          request.present.page_context
        end
      )
    end

    def show
      render_success_response(ride.present.page_context)
    end

    def create
      unless Rides::RideCheckService.perform(user: current_user)
        render_error_response(current_user.errors.messages, :unprocessable_entity) and return
      end

      result = Rides::CreateService.perform ride_params
      render_success_response({ ride: result.present.page_context }, :created)
    end

    def destroy
      Rides::DeleteService.perform(ride: ride)
      render_success_response({}, :no_content)
    end

    # Get from Google Distance Matrix API distance and time of ride between two points
    def distance_matrix
      result = Rides::DistanceService.perform distance_matrix_params
      render_success_response data: result
    end

    private

    def message_params
      params.permit(:id)
    end

    def ride_params
      params.require(:ride).permit(
        :date,
        :payment,
        :start_address,
        :end_address,
        passengers: [],
        message_attributes: %i[message ride_template_id]
      ).merge requestor: current_user, status: 0
    end

    def distance_matrix_params
      params.require(:rides).permit(:time, :start_place_id, :end_place_id)
    end

    def ride
      Ride.find(params[:id])
    end
  end
end
