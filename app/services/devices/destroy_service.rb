# frozen_string_literal: true

module Devices
  # Service for user creation
  class DestroyService < ApplicationService
    # @attr_reader params [Hash]
    # - device [Device]

    def call
      params[:device].destroy
    end

    private

    def device
      params[:device].presence
    end
  end
end