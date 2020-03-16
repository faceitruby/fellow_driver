# frozen_string_literal: true

module Users
  class OmniauthFacebookService < ApplicationService
    # @attr_reader params [String] Token

    def call
      validate_facebook_token
    end

    private

    def validate_facebook_token
      graph = Koala::Facebook::API.new(access_token)
      get_user(graph.get_object('me?fields=email'))
    rescue => e
      OpenStruct.new(success?: false, errors: e.message)
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
      OpenStruct.new(success?: true, data: { token: jwt_encode(user), user: user })
    end

    def access_token
      params['access_token']
    end
  end
end
