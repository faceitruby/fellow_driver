# frozen_string_literal: true

module Notifications
  # Service for user creation
  class DestroyService < ApplicationService
    # @attr_reader params [Hash]
    # notification [Notification] removed notification

    def call
      notification.destroy
    end

    private

    def notification
      params[:notification]
    end
  end
end
