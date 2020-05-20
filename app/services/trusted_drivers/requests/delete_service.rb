# frozen_string_literal: true

module TrustedDrivers
  module Requests
    # Service for request creation
    class DeleteService < ApplicationService
      # @attr_reader params [Hash]
      # - trusted_driver_request: [TrustedDriverRequest] Delete trusted driver request

      def call
        trusted_driver_request.destroy
        OpenStruct.new(success?: true, data: { message: 'deleted' }, errors: nil)
      end

      private

      def trusted_driver_request
        params[:trusted_driver_request]
      end
    end
  end
end
