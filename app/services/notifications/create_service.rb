# frozen_string_literal: true

module Notifications
  # Service for user creation
  class CreateService < ApplicationService
    # @attr_reader params [Hash]
    # title [String]
    # body [Text] Full explanatien
    # type [String] Notification type
    # subject [String] Notification subject

    def call
      infomational_notification
    end

    private

    def infomational_notification
      Notification.create!(notification_params)
    end

    def notification_params
      {
        title: params[:title],
        body: params[:body],
        status: true,
        notification_type: params[:type],
        subject: params[:subject]
      }
    end
  end
end
