# frozen_string_literal: true

module TrustedDrivers
  module Requests
    # Service for request creation
    class DeleteService < ApplicationService
      # - trusted_driver_request: [TrustedDriverRequest] Delete trusted driver request

      def call
        params.destroy
        OpenStruct.new(success?: true, data: { message: 'deleted' }, errors: nil)
      end
    end
  end
end
