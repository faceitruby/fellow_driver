# frozen_string_literal: true

module Users
  class SessionService < ApplicationService
    # @attr_reader params [User] Authenticated user

    def call
      return OpenStruct.new(success?: false, user: nil, errors: 'Invalid Login or password') unless user.present?

      OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user }, errors: nil)
    end

    private

    def user
      params[:user]
    end
  end
end
