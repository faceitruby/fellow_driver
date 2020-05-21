# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :check_authorize, only: :create

    respond_to :json

    # POST api/users/login
    def create
      token = Users::SessionService.perform(user: warden.authenticate)

      render_success_response({ token: token }, :ok)
    end
  end
end
