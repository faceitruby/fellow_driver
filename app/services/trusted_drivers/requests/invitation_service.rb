# frozen_string_literal: true

module TrustedDrivers
  module Requests
    class InvitationService < ApplicationService
      # @attr_reader params [Hash]
      # - phone: [String] Invited user's phone
      # - email: [String] Invited user's email
      # - member_type: [String] Member type in family

      def call
        User.invite!(invite_params, current_user) { |u| u.skip_invitation = true }
      end

      private

      def invite_params
        {
          email: params[:email].presence,
          phone: params[:phone].presence,
          member_type: params[:member_type].presence,
          family_id: params[:current_user].family_id
        }
      end

      def current_user
        params[:current_user].presence
      end
    end
  end
end
