module Connections
  module FamilyConnections
    class UpdateService < ApplicationService
      # @attr_reader params [Hash]
      # - connection: [Connection] connection for updating

      def call
        update_family
        update_family_connection
      end

      private

      def update_family_connection
        connection.update_attribute(:accepted, true)
        connection
      end

      def update_family
        requestor = User.find(connection['requestor_user_id'])
        receiver = User.find(connection['receiver_user_id'])
        member_type = connection['member_type']
        family = requestor.family
        family.users << receiver
        receiver.update_columns(member_type: member_type,
                                family_id: family.id)
      end

      def connection
        params[:connection].presence
      end
    end
  end
end
