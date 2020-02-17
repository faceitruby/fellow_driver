# frozen_string_literal: true

module Users
  class RegistrationService < ApplicationService
    def call
      user = User.new(@params)
      return OpenStruct.new(success?: false, user: nil, errors: user.errors) unless user.save

      OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user }, errors: nil)
    end
  end
end
