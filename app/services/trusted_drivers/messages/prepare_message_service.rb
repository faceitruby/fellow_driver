# frozen_string_literal: true

module TrustedDrivers
  module Messages
    # Service for request creation
    class PrepareMessageService < TrustedDrivers::Messages::ApplicationService
      # @attr_reader params [Hash] Search query
      # - current_user [User] Requestor
      # - user_receiver [User] Invitated user

      def call
        response = {}
        response = response.merge(send_email_message) if user_receiver.email
        response = response.merge(send_phone_message) if user_receiver.phone
        response = response.merge(facebook_message) if user_receiver.uid
        response
      end

      private

      def send_email_message
        TrustedDrivers::Messages::SendEmailService.perform(params)
        { email_message: 'email request sent' }
      end

      def send_phone_message
        Resque.enqueue(InvitePhoneJob, user_receiver.phone, message)
        { phone_message: 'phone request sent' }
      end

      def message
        TrustedDrivers::Messages::CreateService.perform(params)
      end

      def facebook_message
        { facebook_message: { uid: user_receiver.uid, message: message } }
      end
    end
  end
end
