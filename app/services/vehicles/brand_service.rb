# frozen_string_literal: true

module Vehicles
  require 'net/http'
  require 'json'

  class BrandService < ApplicationService
    def call
      threads = []
      result = []
      url = %w[
        https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/car?format=json
        https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/bus?format=json
      ]

      url.each do |uri|
        threads << Thread.new{ examples(URI(uri), 'MakeName') }
      end

      threads.each do |thread|
        result += thread.value
      end

      threads.each &:join
      result
    end

    private

    def examples(url, key)
      JSON.parse(response(url))['Results'].flat_map { |v| v[key] }
    end

    def response(uri)
      Net::HTTP.get(uri)
    end
  end
end
