# frozen_string_literal: true

module Users
  module Registration
    # Service for user creation
    class CreateService < ApplicationService
      # @attr_reader params [Hash]
      # - email: [String] User email
      # - phone: [String] User phone number
      # - password: [String] User password

      def call
        user = User.new(create_params)
        return OpenStruct.new(success?: false, user: nil, errors: user.errors) unless user.save

        OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user }, errors: nil)
      end

      private

      def create_params
        if params['login'].present?
          key = params['login'].include?('@') ? 'email' : 'phone'
          params[key] = params.delete('login')
        end
        params
      end
    end
  end
end
