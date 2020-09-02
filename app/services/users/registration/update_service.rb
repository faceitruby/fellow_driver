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
      # - current_user: [User] Current user

      def call
        user.assign_attributes(params.except('current_user'))
        user.save!
        user
      end

      private

      def user
        params['current_user'].presence
      end
    end
  end
end
