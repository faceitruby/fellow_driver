# frozen_string_literal: true

module FamilyMembers
  class AcceptInvitation < ApplicationService
    # @attr_reader params [Hash]
    # - address: [String] new user address
    # - email: [String] new user email
    # - phone: [String] new user phone number
    # - password: [String] new user password
    # - password_confirmation: [String] new user password confirmation
    # - invitation_token: [String] token to confirm connection

    def call
      raise ArgumentError, 'Invitation token is missing' if invitation_token.nil?

      User.accept_invitation!(params)
    end

    private

    def invitation_token
      params[:invitation_token].presence
    end
  end
end
