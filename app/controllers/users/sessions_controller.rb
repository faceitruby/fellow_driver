# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :check_authorize, only: :create

    respond_to :json

    # POST api/users/login
    def create
      result = Users::SessionService.perform(user: warden.authenticate)
      result.success? ? render_success_response(result.data) : render_error_response(result.errors, 422)
    end
  end
end
