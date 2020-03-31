# frozen_string_literal: true

# Checks presence of payment and trusted drivers
module Rides
  class RideCheckService < ApplicationService
    # @attr_reader params [Hash]
    # - user: [User] User found by token
        
    def call
      # TODO: CHANGE CARS TO TRUSTED_DRIVER REAL OBJECT
      warn "[WARN] Using cars instead trust driver #{__FILE__}:#{__LINE__ + 1}"
      user.errors.add(:cars, 'Connect with your friends to request rides') unless user.cars.any?
      user.errors.add(:payments, 'Please setup a payment method to request rides') unless user.payments.any?
  
      if user.errors.any?
        OpenStruct.new(success?: false, errors: user.errors.messages, data: nil)
      else
        OpenStruct.new(success?: true, errors: nil, data: { message: 'ok' })
      end
    end
  
    private
  
    def user
      params[:user].presence
    end
  end
end
