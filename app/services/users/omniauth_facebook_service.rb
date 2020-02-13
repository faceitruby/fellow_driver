module Users
  class OmniauthFacebookService < ApplicationService
    def initialize(token)
      @token = token
    end

    def execute
      validate_facebook_token
    end

    private

    def validate_facebook_token
      begin
        graph = Koala::Facebook::API.new(@token)
        get_user(graph.get_object("me?fields=email"))
      rescue => e
        message = e.message.instance_of?(String) ? {error: e.message} : e.message
        OpenStruct.new(success?: false, errors: message)
      end
    end

    def get_user(data = {})
      user = User.select(:id, :email, :phone).where(uid: data['id']).take
      unless user
        user = User.new
        user.uid = data['id']
        user.email = data['email']
        user.provider = 'facebook'
        return OpenStruct.new(success?: false, user: nil, errors: user.errors) unless user.save
      end
      OpenStruct.new(success?: true, data: {token: jwt_encode(user), user: user})
    end
  end
end