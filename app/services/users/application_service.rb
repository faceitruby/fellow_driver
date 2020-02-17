# frozen_string_literal: true

# ApplicationService with jwt_encode and jwt_decode methods
class Users::ApplicationService < ApplicationService
  private

  def jwt_encode(data)
    JsonWebToken.encode('user_id' => data.instance_of?(String) ? data : data.id)
  end

  def jwt_decode(token)
    JsonWebToken.decode(token)
  end
end
