# frozen_string_literal: true

module Cars
  # Service for destroy car
  class CarDeleteService < ApplicationService
    # @attr_reader params [Hash]
    # - car: [Car] Deleted car

    def call
      car.destroy.destroyed?
    rescue NoMethodError
      raise ActiveRecord::RecordNotFound
    end

    private

    def car
      params[:car].presence
    end
  end
end
