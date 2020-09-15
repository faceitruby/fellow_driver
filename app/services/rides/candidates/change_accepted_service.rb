# frozen_string_literal: true

module Rides
  module Candidates
    # Requestor accepts driver candidate for a ride
    class ChangeAcceptedService < ApplicationService
      # @attr_reader params [Hash]
      # - id: [Integer] DriverCandidate id for accepting
      # - status: [Symbol] :accepted for accept candidate, :dismissed_by_requestor for not accept candidate

      def call
        raise ArgumentError, 'Status must be set' if value.nil?

        if value == :accepted
          candidate.transaction do
            candidate.update!(status: value)
            candidate.ride.update!(status: :driver_found)
          end
        else
          candidate.update!(status: value)
        end
      end

      private

      def candidate
        @candidate ||= DriverCandidate.find params[:id].presence
      end

      def value
        params[:status]
      end
    end
  end
end
