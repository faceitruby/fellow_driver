# frozen_string_literal: true

module Friends
  class FacebookFriendsService < ApplicationService
    # @attr_reader params [String] Token

    def call
      facebook_friends
    end

    private

    def facebook_friends
      graph = Koala::Facebook::API.new(access_token)
      friends = graph.get_object('me', fields: 'friends')['friends']
      OpenStruct.new(success?: true, data: friends, errors: nil)
    rescue => e
        OpenStruct.new(success?: false, errors: e.message)
    end

    def access_token
      params[:access_token]
    end
  end
end
