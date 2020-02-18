# frozen_string_literal: true

module Users
  module Registration
    class CreateService < ApplicationService
      # @attr_reader params [Hash]
      # - email: [String] User email
      # - phone: [String] User phone number
      # - password: [String] User password

      def call
        user = User.new(@params)
        return OpenStruct.new(success?: false, user: nil, errors: user.errors) unless user.save

        OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user }, errors: nil)
      end
    end
  end
end
