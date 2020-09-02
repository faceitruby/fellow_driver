# frozen_string_literal: true

module Devices
  # Service for user creation
  class CreateService < ApplicationService
    # @attr_reader params [Hash]
    # - platform [String]
    # - user [User] Device owner
    # - registration_ids [String]

    def call
      Device.create!(params)
    end
  end
end
