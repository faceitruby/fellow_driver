# frozen_string_literal: true

class FacebookFriendsController < ApplicationController
  def index
    result = TrustedDrivers::Facebook::FetchFriendsService.perform(
      current_user: current_user, access_token: request.headers['facebooktoken'], near: request.headers['near']
    )
    if result.success?
      render_response result.data
    else
      render_error_response result.errors
    end
  end
end
