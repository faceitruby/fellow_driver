# frozen_string_literal: true

module TrustedDrivers
  class CreateService < ApplicationService
    # @attr_reader params [Hash]
    # - current_user: [User] Current user
    # - trusted_driver_request: [TrustedDriverRequest] Object request to add how trusted_driver

    def call
      raise ArgumentError, 'Receiver is not current user' unless receiver_id == current_user.id

      create_trusted_driver
    rescue NoMethodError
      raise ArgumentError, 'Current_user is missing'
    end

    private

    def create_trusted_driver
      raise ArgumentError, 'Requestor and receiver must exist' if receiver_id.blank? || requestor_id.blank?

      ActiveRecord::Base.transaction do
        trusted_driver_request.update!(accepted: true)
        TrustedDriver.create!(trusted_driver_id: receiver_id, trust_driver_id: requestor_id)
      end
    end

    def receiver_id
      trusted_driver_request.receiver_id
    end

    def requestor_id
      trusted_driver_request.requestor_id
    end

    def current_user
      params[:current_user].presence
    end

    def trusted_driver_request
      return params[:trusted_driver_request].presence if params[:trusted_driver_request].presence

      raise ArgumentError, 'Trusted driver request must exist'
    end
  end
end
