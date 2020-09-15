# frozen_string_literal: true

module Rides
  module Messages
    # fetch all templates for user for choosing one withing ride request creating
    class FetchTemplatesService < TemplatesService
      # @attr_reader params [Hash]
      # - time [String] Picked time
      # - start_address [String] Ride start address
      # - end_address [String] Ride finish address
      # - passengers [Array] Array with passenger ids

      def call
        super

        templates = RideTemplate.all
        templates.each { |template| receive_template!(template) }
        templates
      end

      private

      def parse_time
        raise ArgumentError, 'Date must be in a future' unless correct_time?(scheduled_time)

        super
      end
    end
  end
end
