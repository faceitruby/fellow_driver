# frozen_string_literal: true

module Rides
  class DistanceService < ApplicationService
    # @attr_reader params [Hash]
    # - start_place_id [String] Ride start place_id
    # - end_place_id [String] Ride end place_id
    # - time [String] Time of ride beginning

    def call
      raise ArgumentError, 'ride starting time is missing' if time.blank?
      raise ArgumentError, 'ride start place id is missing' if params[:start_place_id].presence.blank?
      raise ArgumentError, 'ride end place id is missing' if params[:end_place_id].presence.blank?

      result = client.distance_matrix([start_place_id], [end_place_id],
                                      { mode: :driving, departure_time: Time.zone.parse(time).to_i })
      parse_result(result)
    end

    private

    def parse_result(result)
      if %w[NOT_FOUND ZERO_RESULTS].include? result[:rows].first[:elements].first[:status]
        [result[:rows].first[:elements].first[:status]]
      elsif result[:rows].first[:elements].first[:status] == 'OK'
        result[:rows].first[:elements].first.slice(:distance, :duration_in_traffic)
      else
        result
      end
    end

    def time
      params[:time].presence
    end

    def start_place_id
      "place_id:#{params[:start_place_id].presence}"
    end

    def end_place_id
      "place_id:#{params[:end_place_id].presence}"
    end

    def client
      @client ||= GoogleMapsService::Client.new(key: ENV['GOOGLE_DISTANCE_API_KEY'])
    end
  end
end
