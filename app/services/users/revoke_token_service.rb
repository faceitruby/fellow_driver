# frozen_string_literal: true

module Users
  class RevokeTokenService < ApplicationService
    # @attr_reader params [Hash] Authenticated user
    # - current_user [User] Current user from controller

    def call
      return unless current_user

      User.revoke_jwt(current_user.jwt_payload, current_user)
    end
  end
end
