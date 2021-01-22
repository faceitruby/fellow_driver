# frozen_string_literal: true

# ApplicationService with current_user method
module Connections
  module FamilyConnections
    class ApplicationService < ApplicationService
      private

      def current_user
        params[:current_user].presence
      end
    end
  end
end
