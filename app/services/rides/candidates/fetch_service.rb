# frozen_string_literal: true

module Rides
  module Candidates
    class FetchService < ApplicationService
      # @attr_reader params [Hash]
      # - ride_id: [Integer]

      def call
        DriverCandidate.where(ride_id: ride_id)
      end

      private

      def ride_id
        params[:ride_id].presence
      end
    end
  end
end
