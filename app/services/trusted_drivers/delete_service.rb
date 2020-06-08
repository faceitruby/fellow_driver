# frozen_string_literal: true

module TrustedDrivers
  class DeleteService < ApplicationService
    # @attr_reader params [Hash]
    # - trusted_driver: [TrustedDriver] Removed trusted driver

    def call
      # TODO: CHECK WHY CONTROLLER TESTS PASS WITH ANOTHER MESSAGE
      raise ActiveRecord::RecordNotFound, 'Trusted driver not found' unless trusted_driver

      trusted_driver.destroy
    end

    private

    def trusted_driver
      params[:trusted_driver].presence
    end
  end
end
