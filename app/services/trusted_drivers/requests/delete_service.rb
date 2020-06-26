# frozen_string_literal: true

module TrustedDrivers
  module Requests
    # Service for request creation
    class DeleteService < ApplicationService
      # @attr_reader params [Hash]
      # - trusted_driver_request: [TrustedDriverRequest] Delete trusted driver request

      def call
        raise ActiveRecord::RecordNotFound, 'Trusted driver request not found' unless trusted_driver_request

        trusted_driver_request.destroy
      end

      private

      def trusted_driver_request
        params[:trusted_driver_request].presence
      end
    end
  end
end
