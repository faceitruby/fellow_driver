# frozen_string_literal: true

module Users
  module Registration
    # Service for update user. Calls from RegistrationController#update
    class UpdateService < ApplicationService
      # @attr_reader params [Hash]
      # - email: [String] User email
      # - phone: [String] User phone number
      # - first_name: [String] User first name
      # - last_name: [String] User last name
      # - address: [String] User address
      # - avatar: [ActionDispatch::Http::UploadedFile] User avatar
      # - token: [String] Token from request

      def call
        user.assign_attributes(params.except('token'))
        return OpenStruct.new(success?: false, user: nil, errors: user.errors) unless user.save

        OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user }, errors: nil)
      end

      private

      def user
        @user ||= User.find(JsonWebToken.decode(params['token'])['user_id'])
      end
    end
  end
end
