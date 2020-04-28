# frozen_string_literal: true

module TrustedDrivers
  module Requests
    class InvitationService < ApplicationService
      # @attr_reader params [Hash]
      # - phone: [String] Invited user's phone
      # - email: [String] Invited user's email

      def call
        invite = User.invite!(invite_params) { |u| u.skip_invitation = true }
        if invite.errors.empty?
          success_response(invite)
        else
          OpenStruct.new(success?: false, data: nil, errors: invite.errors.messages)
        end
      end

      private

      def success_response(invite)
        OpenStruct.new(success?: true, data: {
                         invite_token: invite.raw_invitation_token,
                         user: invite
                       }, errors: nil)
      end

      def invite_params
        {
          email: params[:email].presence,
          phone: params[:phone].presence
        }
      end
    end
  end
end
