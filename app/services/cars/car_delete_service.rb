# frozen_string_literal: true

module Cars

  # Service for destroy car
  class CarDeleteService < ApplicationService
    def call
    # @attr_reader params [Hash]
    # - car: [Car] Deleted car

    return OpenStruct.new(success?: true, data: { message: 'deleted' }, errors: nil) if params[:car].destroy

    OpenStruct.new(success?: false, data: nil, errors: 'Something went wrong')
    end
  end
end
