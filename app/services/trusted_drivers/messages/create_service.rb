# frozen_string_literal: true

module TrustedDrivers
  module Messages
    # Service for request creation
    class CreateService < TrustedDrivers::Messages::ApplicationService
      # @attr_reader params [Hash] Search query
      # - current_user [User] Requestor
      # - user_receiver [User] Invitated user

      def call
        create_message
      end

      private

      def create_message
        "#{current_user.name} is inviting you to connect on KydRides.\
        Please click the link to accept the invitation:\
        #{link}"
      end

      def token
        user_receiver.raw_invitation_token
      end

      def link
        if token
          "#{ENV['HOST_ADDRESS']}/api/users/invitation/accept?invitation_token=#{token}"
        else
          "#{ENV['HOST_ADDRESS']}/api/trusted_driver_requests"
        end
      end
    end
  end
end
