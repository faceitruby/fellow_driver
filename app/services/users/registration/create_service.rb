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
        user = User.new(create_params)
        user.build_family
        user.save!
      end

      private

      def create_params
        return params.merge(member_type: 'owner') if params['login'].blank?

        key = params['login'].include?('@') ? 'email' : 'phone'
        params.merge(key => params.delete('login'), member_type: 'owner')
      end
    end
  end
end
