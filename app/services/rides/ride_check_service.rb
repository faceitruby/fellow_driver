# frozen_string_literal: true

# Checks presence of payment and trusted drivers
module Rides
  class RideCheckService < ApplicationService
    # @attr_reader params [Hash]
    # - user: [User] User found by token

    def call
      user.errors.add(:trusted_drivers, 'Connect with your friends to request rides') unless user.trusted_drivers.any?
      user.errors.add(:payments, 'Please setup a payment method to request rides') unless user.payments.any?

      user.errors.empty?
    end

    private

    def user
      params[:user].presence
    end
  end
end
