# frozen_string_literal: true

module TrustedDrivers
  module Requests
    # Service for request creation
    class CreateService < ApplicationService
      # @attr_reader params [Hash] Search query
      # - current_user [User] User requestor
      # - phone [String] Requested user's phone
      # - email [String] Requested user's email
      # - uid [String] Requested user's uid
      # - member_type [String] Member type in family

      def call
        user = TrustedDrivers::UserSearchService.perform(params.except(:current_user)) ||
               TrustedDrivers::Requests::InvitationService.perform(params)
        create_request(user)
        send_message(user)
      end

      private

      def create_request(user)
        TrustedDriverRequest.new(trusted_driver(user)).save!
      end

      def send_message(user_receiver)
        TrustedDrivers::Messages::PrepareMessageService.perform(
          user_receiver: user_receiver,
          current_user: current_user
        )
      end

      def trusted_driver(reseiver)
        {
          receiver_id: reseiver.id,
          requestor_id: current_user.id
        }
      end

      def current_user
        params[:current_user].presence
      end
    end
  end
end
