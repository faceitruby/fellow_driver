# frozen_string_literal: true

module Users
  class OmniauthFacebookService < ApplicationService
    # @attr_reader params [Hash]
    # - access_token: [String] Token

    def call
      jwt_encode receive_user
    end

    private

    def validate_facebook_token
      raise ArgumentError, 'facebook access token is missing' if access_token.nil?
    end

    def receive_user
      validate_facebook_token
      graph = Koala::Facebook::API.new(access_token)
      data = graph.get_object('me?fields=email')

      User.find_by(uid: data['id']) || User.create!(create_params(data))
    end

    def access_token
      params['access_token'].presence
    end

    def create_params(data)
      { uid: data['id'],
        email: data['email'],
        provider: 'facebook',
        member_type: 'owner',
        family_attributes: {} }
    end
  end
end
