# frozen_string_literal: true

module Rides
  module Candidates
    class CreateService < ApplicationService
      # @attr_reader params [Hash]
      # - driver_id: [Integer] User who accepting ride.
      # - id: [Integer] Ride id
      # - status: [Symbol] Candidate status

      def call
        check_params!

        if status == :created && not_dismissed_candidates.size.positive?
          message = accepted_exists? ? 'Driver already accepted' : 'Candidate is under consideration'
          notificate_driver message, driver.id
          return message
        end

        candidate = DriverCandidate.create!(driver: driver, ride: ride, second_connection: second_connection?)

        case status
        when :accepted
          # accept driver if he is from first connection
          ChangeAcceptedService.perform(id: candidate.id, status: :accepted) unless candidate.second_connection
        when :dismissed_by_candidate
          ChangeAcceptedService.perform(id: candidate.id, status: status)
        end

        candidate
      end

      private

      def check_params!
        raise ArgumentError, 'Driver is missing' if params[:driver_id].nil?
        raise ArgumentError, 'Ride is missing' if params[:id].nil?
        raise ArgumentError, 'Status is missing' if params[:status].nil?
        raise ArgumentError, 'Not a trusted driver' unless trusted_driver_for_requestor?
      end

      def second_connection?
        driver.trust_drivers.pluck(:trust_driver_id).exclude? ride.requestor.id
      end

      def driver
        @driver ||= User.includes(:trust_drivers).find params[:driver_id].presence
      end

      def ride
        @ride ||= Ride.includes(requestor: :trusted_drivers).find params[:id].presence
      end

      # check if the driver is a first of second connection trusted driver for a requestor
      def trusted_driver_for_requestor?
        ride.requestor.trusted_drivers.pluck(:trusted_driver_id).include?(driver.id) ||
          (ride.requestor.trusted_drivers.pluck(:trusted_driver_id) & driver.trust_drivers.pluck(:trust_driver_id))
            .present?
      end

      def not_dismissed_candidates
        @not_dismissed_candidates ||= ride.driver_candidates.where(status: %i[created accepted])
      end

      def accepted_exists?
        not_dismissed_candidates.exists?(status: :accepted)
      end

      def notificate_driver(message, driver_id)
        Resque.enqueue(InformDriverJob, message, driver_id)
      end

      def status
        params[:status].presence
      end
    end
  end
end
