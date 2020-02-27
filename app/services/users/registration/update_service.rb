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
        receive_user.assign_attributes(params.except('token'))

        return OpenStruct.new(success?: false, user: nil, errors: receive_user.errors) unless receive_user.save

        OpenStruct.new(success?: true, data: { token: jwt_encode(receive_user), user: receive_user }, errors: nil)
      end

      private

      def receive_user
        @receive_user ||= User.find(JsonWebToken.decode(params['token'])['user_id'])
      end
    end
  end
end
