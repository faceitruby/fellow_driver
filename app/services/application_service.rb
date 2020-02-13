class ApplicationService
  def initialize(params = {})
    @params = params
  end

  def self.perform(params = {}, &block)
    new(params).call(&block)
  end

  private

  def jwt_encode(data)
    JsonWebToken.encode('user_id' => data.instance_of?(String) ? data : data.id)
  end

  def jwt_decode(token)
    JsonWebToken.decode(token)
  end
  attr_reader :params
end
