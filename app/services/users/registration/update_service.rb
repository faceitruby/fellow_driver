
# frozen_string_literal: true

module Users
  module Registration
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
        user = receive_user
        user.assign_attributes(@params.except('token'))

        return OpenStruct.new(success?: false, user: nil, errors: user.errors) unless user.save

        OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user }, errors: nil)
      end

      private

      def receive_user
        decoded = JsonWebToken.decode @params['token']
        User.find(decoded['user_id'])
      end
    end
  end
end
