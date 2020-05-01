# frozen_string_literal: true

require 'json_web_token'
module Users
  # ApplicationService with jwt_encode and jwt_decode methods
  class ApplicationService < ApplicationService
    private

    def jwt_encode(data)
      JsonWebToken.encode('user_id' => data.instance_of?(String) ? data : data.id)
    end

    def jwt_decode(token)
      JsonWebToken.decode(token)
    end

    def current_user
      params[:current_user].presence
    end
  end
end
