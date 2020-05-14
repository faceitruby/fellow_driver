# frozen_string_literal: true

module Notifications
  # Service for user creation
  class PushService < ApplicationService
    # @attr_reader params [Hash]
    # notification [Notification]
    # registration_ids [Array] an array of one or more client registration tokens
    def call
      # response = fcm_client.send(reseivers, options)

      raise ArgumentError, 'The list of devices must be filled' unless reseivers.present?

      n = Rpush::Gcm::Notification.new
      n.app = app_client
      n.registration_ids = reseivers
      n.data = { message: options['title'] }
      n.content_available = true
      n.notification = options
      n.save!
    end

    private

    def options
      {
        title: notification.title,
        body: notification.body,
        notification_type: notification.notification_type,
        status: notification.status
      }
    end

    def reseivers
      params[:registration_ids].presence
    end

    def notification
      params[:notification]
    end

    def app_client
      app = Rpush::Gcm::App.find_by_name('qwer')
      app || create_client
    end

    def create_client
      app = Rpush::Gcm::App.new
      app.name = 'qwer'
      app.auth_key = ENV['FCM_SEVER_KEY']
      app.connections = 1
      app.save!
      app
    end
  end
end
