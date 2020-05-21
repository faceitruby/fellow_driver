# frozen_string_literal: true

module  Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :check_authorize, only: %i[facebook]

    respond_to :json

    # POST api/users/auth/facebook
    def facebook
      token = OmniauthFacebookService.perform(facebook_params)

      render_success_response({ token: token }, :ok)
    end

    private

    def facebook_params
      params.permit(:access_token)
    end
  end
end
