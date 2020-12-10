# frozen_string_literal: true

module Connections
  module FamilyConnections
    class CreateService < ApplicationService
      # @attr_reader params [Hash]
      # - requestor_user: [User] Current_user
      # - receiver_user: [User] User who receives the connection
      # - member_type: relationship between receiver_user and requestor_user

      def call
        raise ArgumentError, 'Requester is missing' if requestor_user.blank?
        raise ArgumentError, 'Receiver is missing' if receiver_user.blank?
        raise ArgumentError, 'Member Type is missing' if member_type.blank?
        raise ArgumentError, 'The Recipient cannot be the Sender' if receiver_user == requestor_user

        create_family_connection
      end

      private

      def create_family_connection
        FamilyConnection.create!(
          requestor_user_id: requestor_user.id,
          receiver_user_id: receiver_user.id,
          member_type: member_type
        )
      end

      def requestor_user
        params[:requestor_user]
      end

      def receiver_user
        params[:receiver_user]
      end

      def member_type
        params[:member_type]
      end
    end
  end
end
