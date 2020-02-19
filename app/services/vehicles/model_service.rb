module Vehicles
  require 'net/http'
  require 'json'

  class ModelService < ApplicationService
    # @attr_reader params [Hash]
    # - brand: [String] Car brand name

    def call(brand)
      brand = brand.strip.gsub(' ', '_')
      url = URI("https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/#{ brand }?format=json")
      examples(url, 'Model_Name')
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
