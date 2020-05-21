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
        near? ? near_friends : friends_uid
      end

      def friends_uid
        friends = graph.get_object('me', fields: 'friends')['friends']['data']
        result = friends.map { |friend| User.find_by(uid: friend['uid']) }
        # result is [nil] when facebook friends doesn\'t exists in DB, we need to remove nils from result
        result.reject(&:blank?)
      end

      def graph
        @graph ||= Koala::Facebook::API.new(access_token)
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
