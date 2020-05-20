# frozen_string_literal: true

module TrustedDrivers
  module Messages
    # Service for request creation
    class PrepareMessageService < TrustedDrivers::Messages::ApplicationService
      # @attr_reader params [Hash] Search query
      # - current_user [User] Requestor
      # - user_receiver [User] Invitated user

      def call
        response = OpenStruct.new(success?: true, data: {})
        response.data = response.data.merge(send_email_message) if user_receiver.email
        response.data = response.data.merge(send_phone_message) if user_receiver.phone
        response.data = response.data.merge(facebook_message) if user_receiver.uid
        response
      end

      private

      def send_email_message
        TrustedDrivers::Messages::SendEmailService.perform(params)
        { email_message: 'email request sended' }
      end

      def send_phone_message
        Resque.enqueue(InvitePhoneJob, user_receiver.phone, message)
        { phone_message: 'phone request sended' }
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
