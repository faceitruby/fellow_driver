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
      rescue
        return OpenStruct.new(success?: false, errors: {token: 'token is not valid'})
      end
    end

    def get_user(data = {})
      # graph = Koala::Facebook::API.new(@token)
      # graph.get_object("me?fields=email")
      user = User.find_by(uid: data['id'])
    end

  end
end