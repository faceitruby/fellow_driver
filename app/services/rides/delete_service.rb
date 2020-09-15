# frozen_string_literal: true

module Rides
  class DeleteService < ApplicationService
    # @attr_reader params [Hash]
    # - ride: [Ride] Removed ride

    def call
      raise ArgumentError, 'Ride request not found' unless ride

      ride.destroy
    end

    private

    def ride
      params[:ride].presence
    end
  end
end
