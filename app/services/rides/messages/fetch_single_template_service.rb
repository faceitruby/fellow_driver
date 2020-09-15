# frozen_string_literal: true

module Rides
  module Messages
    # fetch ride template for existing ride request
    class FetchSingleTemplateService < TemplatesService
      # @attr_reader params [Hash]
      # - id [Integer] Ride id

      def initialize(params = {})
        super template_params(params[:id])
      end

      def call
        super

        receive_template! RideTemplate.find(id), parse_time(@ride.created_at)
      end

      private

      def ride(ride_request_params)
        @ride ||= Ride.includes(:message).find ride_request_params.presence
      end

      def template_params(ride)
        raise ArgumentError, 'Template id is missing' unless ride
        if ride(ride).message&.ride_template_id.blank?
          raise ArgumentError, 'This ride request doesn\'t use ride_templates'
        end

        {
          id: ride(ride).message.ride_template_id,
          time: ride(ride).date.to_s,
          start_address: ride(ride).start_address,
          end_address: ride(ride).end_address,
          passengers: ride(ride).passengers
        }
      end
    end
  end
end
