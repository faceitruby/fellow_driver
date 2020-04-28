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

      def call
        result = TrustedDrivers::UserSearchService.perform(params.except(:current_user))
        if result.success?
          create_request(result)
        else
          result = TrustedDrivers::Requests::InvitationService.perform(params)
          if result.success?
            create_request(result)
          else
            response(false, nil, result.errors)
          end
        end
      end

      private

      def create_request(result)
        trusted_driver_request = TrustedDriverRequest.new(trusted_driver(result.data[:user]))
        if trusted_driver_request.save
          sended_message = send_message(result.data[:user])
          response(true, { messages: sended_message.data, user: result.data[:user] }, nil)
        else
          response(false, nil, trusted_driver_request.errors)
        end
      end

      def response(success, data, errors)
        OpenStruct.new(success?: success, data: data, errors: errors)
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
