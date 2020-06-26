# frozen_string_literal: true

module Users
  class SessionService < ApplicationService
    # @attr_reader params [User] Authenticated user

    def call
      raise ActiveRecord::RecordNotFound, 'Invalid login or password' if user.nil?

      jwt_encode(user)
    end

    private

    def user
      params[:user].presence
    end
  end
end
