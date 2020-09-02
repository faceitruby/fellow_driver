# frozen_string_literal: true

module Cars
  # Service for create car
  class CarCreateService < ApplicationService
    # @attr_reader params [Hash]
    # - manufacturer: [String] Car brand name
    # - model: [String] Car model name
    # - year: [String] Year of manufacture of a car
    # - picture: [String] Car picture
    # - color: [String] Car color
    # - license_plat_number: [String] Car license plat number
    # - user: [User] Current user

    def call
      car = user.cars.new(params)
      car.save!
      car
    end

    private

    def user
      params[:user].presence
    end
  end
end
