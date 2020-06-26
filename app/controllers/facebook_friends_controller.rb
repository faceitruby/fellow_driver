# frozen_string_literal: true

class FacebookFriendsController < ApplicationController
  def index
    result = TrustedDrivers::Facebook::FetchFriendsService.perform(fetch_params)

    render_success_response(facebook_friends: result.map { |user| user.present.page_context })
  end

  private

  def fetch_params
    if request.headers['access-token-fb'].blank?
      raise Koala::Facebook::AuthenticationError.new(401, 'Facebook access token is missing')
    end

    { current_user: current_user,
      access_token: request.headers['access-token-fb'],
      near: request.headers['near'] }
  end
end
