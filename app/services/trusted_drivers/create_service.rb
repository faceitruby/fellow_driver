# frozen_string_literal: true

module TrustedDrivers
  class CreateService < ApplicationService
    # @attr_reader params [Hash]
    # - current_user: [User] Current user
    # - trusted_driver_request: [TrustedDriverRequest] Object request to add how trusted_driver

    def call
      if trusted_driver_request && receiver_id == current_user.id
        create_trusted_driver
        OpenStruct.new(success?: true, data: { message: 'created' }, errors: nil)
      else
        OpenStruct.new(success?: false, data: nil, errors: 'something went wrong')
      end

    rescue ArgumentError => e
      OpenStruct.new(success?: false, data: nil, errors: e.message)
    end

    private

    def create_trusted_driver
      raise ArgumentError.new('Requestor and receiver must exist') if receiver_id.blank?	 || requestor_id.blank?

      TrustedDriver.create(trusted_driver_id: receiver_id, trust_driver_id: requestor_id)
      trusted_driver_request.update(accepted: true)
    end

    def receiver_id
      trusted_driver_request&.receiver_id
    end

    def requestor_id
      trusted_driver_request&.requestor_id
    end

    def current_user
      params[:current_user].presence
    end

    def trusted_driver_request
      params[:trusted_driver_request].presence
    end
  end
end
