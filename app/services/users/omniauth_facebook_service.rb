# frozen_string_literal: true

module Users
  class OmniauthFacebookService < ApplicationService
    # @attr_reader params [Hash]
    # - access_token: [String] Token

    def call
      user = validate_facebook_token
      jwt_encode(user)
    end

    private

    def validate_facebook_token
      raise ArgumentError, 'facebook access token is missing' if access_token.nil?

      graph = Koala::Facebook::API.new(access_token)
      get_user(graph.get_object('me?fields=email'))
    end

    def get_user(data = {})
      user = User.select(:id, :email, :phone).where(uid: data['id']).take
      unless user
        user = User.new
        user.uid = data['id']
        user.email = data['email']
        user.provider = 'facebook'
        user.member_type = 'owner'
        user.build_family
        user.save!
      end
      user
    end

    def access_token
      params['access_token'].presence
    end
  end
end
