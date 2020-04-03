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

        return OpenStruct.new(success?: false, user: nil, errors: user.errors) unless user.save

        user.create_family
        user.update_attribute('family_id', user.family.id)
        OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user }, errors: nil)
      rescue ActiveRecord::RecordNotUnique => e
        OpenStruct.new(success?: false, user: nil, errors: error(e.message))
      end

      private

      def create_params
        return params.merge(member_type: 'owner') unless params['login'].present?

        key = params['login'].include?('@') ? 'email' : 'phone'
        params.merge(key => params.delete('login'))
      end

      # Simplifies error description
      #
      # @example:
      #   error("PG::UniqueViolation: ERROR:  duplicate key value violates unique constraint \"index_users_on_email\"\n
      #         DETAIL:  Key (phone)=(123-456-7890) already exists.\n") #=> "Key (phone)=(123-456-7890) already exists."
      #
      # @param message [String] ActiveRecord error message
      #
      # @return [String] Simplified error description
      def error(message)
        detail = message.lines.second
        detail[detail.index('Key')..-2]
      end
    end
  end
end
