# frozen_string_literal: true

module Notifications
  class SetReceivingService < ApplicationService
    # @attr_reader params [Hash]
    # user [User] Target user
    # status [Boolean] Desired status

    def call
      user.update(notifications_enabled: status)
    end

    private

    def user
      params[:user].presence
    end

    def status
      params[:status].present?
    end
  end
end
