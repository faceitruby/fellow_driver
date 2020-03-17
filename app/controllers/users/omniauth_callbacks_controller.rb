# frozen_string_literal: true

module  Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :check_authorize, only: %i[facebook]

    respond_to :json

    # POST api/users/auth/facebook
    def facebook
      result = OmniauthFacebookService.perform(facebook_params)
      result.success? ? render_success_response(result.data) : render_error_response(result.errors)
    end

    private

    def facebook_params
      params.permit(:access_token)
    end
  end
end
