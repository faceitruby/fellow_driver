# frozen_string_literal: true

module Vehicles
  require 'net/http'

  # Service for get brands Avto from API
  class BrandListService < Vehicles::ApplicationService
    def call
      threads = []
      result = []
      url = %w[
        https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/car?format=json
        https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/bus?format=json
      ]
      url.each do |uri|
        threads << Thread.new { examples(URI(uri), 'MakeName') }
      end

      threads.each do |thread|
        result += thread.value
      end

      threads.each(&:join)
      result
    end
  end
end
