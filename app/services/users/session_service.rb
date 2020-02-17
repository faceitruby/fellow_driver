# frozen_string_literal: true

module Users
  class SessionService < ApplicationService
    def call
      return OpenStruct.new(success?: false, user: nil, errors: 'Invalid Login or password') unless @params

      OpenStruct.new(success?: true, data: { token: jwt_encode(@params), user: @params }, errors: nil)
    end
  end
end
