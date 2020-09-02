# frozen_string_literal: true

module Notifications
  # Service for user creation
  class FetchRegistrationIdsService < ApplicationService
    # @attr_reader params [Hash]
    # user [User]

    def call
      get_ids
    end

    private

    def get_ids
      raise ArgumentError, 'No registered ids for user' unless user.present?

      user_ids = []
      user&.devices.each do |device|
        user_ids.push(device.registration_ids)
      end
      user_ids
    end

    def user
      params[:user]
    end
  end
end