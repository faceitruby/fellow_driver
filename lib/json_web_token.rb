# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = ENV.fetch 'DEVISE_JWT_SECRET_KEY'

  def self.encode(payload, expire = 24.hours.from_now)
    payload[:expire] = expire.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
