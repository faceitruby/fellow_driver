# frozen_string_literal: true

module Rides
  class FetchPlaceIdService < ApplicationService
    #  @attr_reader params [Hash]
    # - address [String] Address

    def call
      check_params!

      Geocoder.search(address).first.place_id
    end

    private

    def address
      params[:address].presence
    end

    def check_params!
      raise ArgumentError, 'Address is missing' if address.blank?
    end
  end
end
