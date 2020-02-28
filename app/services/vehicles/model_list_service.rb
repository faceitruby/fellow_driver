# frozen_string_literal: true

module Vehicles
  require 'net/http'
  require 'json'

  # Service for get models Avto from API by brand
  class ModelListService < Vehicles::ApplicationService
    # @attr_reader params [Hash]
    # - brand: [String] Car brand name

    def call
      brand = params.strip.gsub(' ', '_')
      url = URI("https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/#{brand}?format=json")
      examples(url, 'Model_Name')
    end
  end
end
