# frozen_string_literal: true

module TrustedDrivers
  class CreateService < ApplicationService
    # @attr_reader params [Hash]
    # - current_user: [User] Current user
    # - trusted_driver_request: [TrustedDriverRequest] User added how trusted_driver for current user

    def call
      if trusted_driver.save
        TrustedDrivers::Requests::DeleteService.perform(trusted_driver_request)
        OpenStruct.new(success?: true, data: { message: 'created' }, errors: nil)
      else
        OpenStruct.new(success?: false, data: nil, errors: trusted_driver.errors)
      end
    end

    private

    def trusted_driver
      TrustedDriver.new(trusted_driver_id: receiver_id, trust_driver_id: requestor_id)
    end

    def receiver_id
      trusted_driver_request[:receiver_id] if trusted_driver_request
    end

    def requestor_id
      trusted_driver_request[:requestor_id] if trusted_driver_request
    end

    def current_user
      params[:current_user].presence
    end

    def trusted_driver_request
      params[:trusted_driver_request].presence
    end
  end
end
