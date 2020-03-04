# frozen_string_literal: true

module Cars
  # Service for destroy car
  class CarDeleteService < ApplicationService
    # @attr_reader params [Hash]
    # - car: [Car] Deleted car

    def call
      return OpenStruct.new(success?: true, data: { message: 'deleted' }, errors: nil) if car.destroy

      OpenStruct.new(success?: false, data: nil, errors: 'Something went wrong')
    end

    private

    def car
      params[:car].presence
    end
  end
end
