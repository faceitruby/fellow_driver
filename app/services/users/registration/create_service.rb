# frozen_string_literal: true

module Users
  module Registration
    # Service for user creation
    class CreateService < ApplicationService
      # @attr_reader params [Hash]
      # - email: [String] User email
      # - phone: [String] User phone number
      # - password: [String] User password
      # - login: [String] User email or phone

      def call
        User.create!(create_params)
      end

      private

      def create_params
        attributes = params.merge(member_type: 'owner', family_attributes: {})
        return attributes if attributes['login'].blank?

        key = attributes['login'].include?('@') ? 'email' : 'phone'
        attributes.merge(key => attributes.delete('login'))
      end
    end
  end
end
