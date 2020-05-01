# frozen_string_literal: true

module TrustedDrivers
  module Messages
    # Service for request creation
    class SendEmailService < TrustedDrivers::Messages::ApplicationService
      # @attr_reader params [Hash] Search query
      # - current_user [User] Requestor
      # - user_receiver [User] Invitated user

      def call
        Resque.enqueue(InviteEmailJob, current_user.name, user_receiver, url)
      end

      private

      def url
        "#{ENV['HOST_ADDRESS']}/api/users/invitation/accept?invitation_token=#{token}"
      end

      def token
        user_receiver.raw_invitation_token
      end
    end
  end
end
