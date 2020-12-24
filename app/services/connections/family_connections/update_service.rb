# frozen_string_literal: true

module Connections
  module FamilyConnections
    class UpdateService < ApplicationService
      # @attr_reader params [Hash]
      # - id: id of the connection
      # - current_user: [User] Current_user

      def call
        raise ArgumentError, 'Connection is missing' if params[:id].blank?
        raise ArgumentError, 'Receiver is missing' if current_user.blank?

        update_family
        update_family_connection
        connection
      end

      private

      def update_family
        current_user.update_column(:member_type, member_types)
        current_user.family.users.each do |member|
          requester.family.users << member
        end
      end

      def update_family_connection
        connection.update_column(:accepted, true)
      end

      def connection
        current_user.receiver_user_family_connections.find(params[:id])
      end

      def requester
        User.find(connection['requestor_user_id'])
      end

      def member_types
        connection['member_type']
      end
    end
  end
end
