# frozen_string_literal: true

module Users
  class CurrentUserService < ApplicationService
    # @attr_reader params [User] Authenticated user

    def call
      user = JsonWebToken.decode(@params)
      user = User.find(user[:user_id])
    end
  end
end
