# frozen_string_literal: true

module Connections
  module FamilyConnections
    class UpdateService < ApplicationService
      # @attr_reader params [Hash]
      # - connection: [Connection] connection for updating

      def call
        raise ArgumentError, 'Connection is missing' if connection.blank?

        update_family
        update_family_connection
      end

      private

      def update_family
        requester = User.find(connection['requestor_user_id'])
        receiver = User.find(connection['receiver_user_id'])
        member_types = connection['member_type']
        receiver.update_column(:member_type, member_types)
        receiver.family.users.each do |member|
          requester.family.users << member
        end
      end

      def update_family_connection
        connection.update_column(:accepted, true)
        connection
      end

      def connection
        params[:connection].presence
      end
    end
  end
end
