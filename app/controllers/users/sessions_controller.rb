class Users::SessionsController < Devise::SessionsController
  skip_before_action :check_authorize, only: [:create]

  respond_to :json

  # POST api/users/login
  def create
    result = Users::SessionService.new(warden.authenticate).perform
    result.success? ? render_success_response(result.data) : render_error_response(result.errors)
  end
end
