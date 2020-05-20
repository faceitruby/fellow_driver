# frozen_string_literal: true

module Users
  # Service for autocomplete addresses using Google Place Autocomplete
  class AddressAutocompleteService < ApplicationService
    # @attr_reader params [Hash] Search query
    # - input [String] What are we looking for (required)
    # - types [String] The types of place results to return (optional)
    # - language [String] The language code, indicating in which language the results should be returned (optional)
    # - radius [String] The distance (in meters) within which to return place results (optional)
    # - lat [String] Latitude (optional)
    # - lng [String] Longitude (optional)
    #
    # @see https://developers.google.com/places/web-service/autocomplete#place_autocomplete_requests

    def call
      response = autocomplete_client.autocomplete(receive_params)
      return_response(response)
    end

    private

    def return_response(response)
      json = JSON.parse response.body

      case json['status']
      when 'OK'
        OpenStruct.new(success?: true, data: json['predictions'], errors: nil)
      when 'ZERO_RESULTS'
        OpenStruct.new(success?: true, data: json['status'], errors: nil)
      when 'OVER_QUERY_LIMIT', 'REQUEST_DENIED', 'INVALID_REQUEST'
        OpenStruct.new(success?: false, data: nil, errors: json['status'])
      else
        OpenStruct.new(success?: false, data: nil, errors: 'UNKNOWN_ERROR')
      end
    end

    def receive_params
      my_params = params.except(:token)
      my_params.merge!(session_token: find_session_token)
      my_params.merge!(language: language) unless my_params.key?(:language)
      my_params.merge!(types: 'address') unless my_params.key?(:types)
      my_params.to_h.symbolize_keys
    end

    def find_session_token
      redis = Redis.new
      session_token = redis.get params['token']
      unless session_token
        session_token = generate_session_token
        redis.set params['token'], session_token, ex: 180
      end
      session_token
    end

    def generate_session_token
      SecureRandom.uuid
    end

    def language
      I18n.locale
    end

    def autocomplete_client
      @autocomplete_client ||= GooglePlacesAutocomplete::Client.new(api_key: ENV['GOOGLE_PLACES_API_KEY'])
    end
  end
end
