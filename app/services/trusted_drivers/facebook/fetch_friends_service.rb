# frozen_string_literal: true

module TrustedDrivers
  module Facebook
    class FetchFriendsService < ApplicationService
      # @attr_reader params [Hash]
      # - current_user [User]
      # - access_token [String] Facebook access token
      # - near [Bolean] Show users in distance 25 miles

      def call
        facebook_friends
      end

      private

      def facebook_friends
        friends_list = friends_uid

        if near?
          OpenStruct.new(success?: true, data: near_friends)
        else
          OpenStruct.new(success?: true, data: friends_list, errors: nil)
        end
      rescue Koala::Facebook::ClientError => e
        OpenStruct.new(success?: false, errors: e.message)
      end

      def friends_uid
        graph = Koala::Facebook::API.new(access_token)
        friends = graph.get_object('me', fields: 'friends')['friends']['data']
        friends.map { |friend| User.find_by(uid: friend['id']) }
      end

      def access_token
        params[:access_token].presence
      end

      def current_user
        params[:current_user].presence
      end

      def near?
        ActiveRecord::Type::Boolean.new.cast(params[:near].presence)
      end

      def near_friends
        friends_uid.select { |friend| in_radius?(friend) }
      end

      def in_radius?(friend)
        return false unless current_user.address && friend.address

        current_adress = Geocoder.search(current_user.address)[0].coordinates
        friend_adress = Geocoder.search(friend.address)[0].coordinates
        Geocoder::Calculations.distance_between(current_adress, friend_adress) < 25
      end
    end
  end
end
