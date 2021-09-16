# frozen_string_literal: true

module Users
  # Service for autocomplete addresses using Google Place Autocomplete
  class DistanceMatrixService < ApplicationService
    def call
      raise ArgumentError, "Origin must be provided" unless params[:origin]
      raise ArgumentError, "Destination must be provided" unless params[:destination]

      prepare_matrix
      prepare_response
    end

    private

    def prepare_response
      response = distance_matrix_client.data.first.first
      if response.status == 'ok'
        {
          distance_text: response.distance_text,
          distance_in_meters: response.distance_in_meters,
          duration_text: response.duration_text,
          duration_in_seconds: response.duration_in_seconds
        }
      else
        { error: 'Check the data' }
      end
    end

    def prepare_matrix
      distance_matrix_client.origins << origin
      distance_matrix_client.destinations << destination
    end

    def origin
      GoogleDistanceMatrix::Place.new(address: params[:origin])
    end

    def destination
      GoogleDistanceMatrix::Place.new(address: params[:destination])
    end

    def distance_matrix_client
      @_distance_matrix_client ||= GoogleDistanceMatrix::Matrix.new
    end
  end
end
