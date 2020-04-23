# frozen_string_literal: true

module Notifications
    # Service for user creation
    class CreateService < ApplicationService
      # @attr_reader params [Hash]
      # title [String]
      # body [Text] Full explanatien
      # type [String] Notification type
      # user [User] Notification target

      def call
        infomational_notification
      end

      private

      def infomational_notification
        Notification.create!(params)
      end

      def notification_params
        {
          title: params[:title],
          body: params[:body],
          status: true,
          type: params[:type],
          user_id: user.id
        }
      end

      def user
        params[:user].presence
      end
    end
  end
end
