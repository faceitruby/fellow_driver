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
      raise ArgumentError, 'Input parameter is missing' if params['input'].blank?

      response = autocomplete_client.autocomplete(receive_params)
      result = JSON.parse response.body
      check_response(result)
      result['predictions']
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    def check_response(response)
      case response['status']
      when 'INVALID_REQUEST'
        raise ArgumentError, response['error_message'] || 'Input parameter is missing'
      when 'REQUEST_DENIED'
        raise ArgumentError, response['error_message'] || 'Key is missing or invalid'
      when 'OVER_QUERY_LIMIT'
        raise OverQuotaLimitError, response['error_message'] || 'You are over your quota'
      when 'UNKNOWN_ERROR'
        raise UnknownError, response['error_message'] || response['status']
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def receive_params
      my_params = params.except(:token)
      my_params[:session_token] = find_session_token
      my_params[:language] = language unless my_params.key?(:language)
      my_params[:types] = 'address' unless my_params.key?(:types)
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

    class OverQuotaLimitError < StandardError; end
    class UnknownError < StandardError; end
  end
end
