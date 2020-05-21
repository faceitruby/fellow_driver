# frozen_string_literal: true

module TrustedDrivers
  class DeleteService < ApplicationService
    # @attr_reader params [Hash]
    # - trusted_driver: [TrustedDriver] Removed trusted driver

    def call
      trusted_driver.destroy!.destroyed?
    rescue NoMethodError
      raise ArgumentError, 'Trusted_driver is missing'
    end

    private

    def trusted_driver
      params[:trusted_driver].presence
    end
  end
end
