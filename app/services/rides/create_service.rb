# frozen_string_literal: true

module Rides
  class CreateService < ApplicationService
    # @attr_reader params [Hash]
    # - passengers: [Array] Contain list of passengers ids
    # - date: [String] Ride's start time
    # - start_address [String] start address of ride
    # - end_address [String] end address of ride
    # - payment [Integer] the cost of ride
    # - requestor [User] User who creates ride
    # - ride_message_attributes [Array] Attributes for ride_message creating, only one should be present
    # - - message [String] Custom message
    # - - ride_template_id [Integer] Ride template id

    def call
      ride = Ride.create!(params)
      Rides::NotificateDriversService.perform(notificate_params)
      ride
    end

    private

    def notificate_params
      {
        second_connection: false,
        id: requestor.id
      }
    end

    def requestor
      params[:requestor].presence
    end
  end
end
