# frozen_string_literal: true

module TrustedDrivers
  class DeleteService < ApplicationService
    # @attr_reader params [Hash]
    # - trusted_driver: [TrustedDriver] Removed trusted driver

    def call
      trusted_driver.destroy
      OpenStruct.new(success?: true, data: { message: 'deleted' }, errors: nil)
    end

    private

    def trusted_driver
      params[:trusted_driver].presence
    end
  end
end
