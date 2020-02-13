# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # POST api/users/login
  def create
    result = Users::SessionService.new(warden.authenticate).execute
    result.success? ? render_success_response(result.data) : render_error_response(result.errors)
  end
end
