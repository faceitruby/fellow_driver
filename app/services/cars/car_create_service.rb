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
      car = params['user'].cars.new(params)
      return OpenStruct.new(success?: false, data: nil, errors: car.errors) unless car.save

      OpenStruct.new(success?: true, data: { car: car }, errors: nil)
    end
  end
end
