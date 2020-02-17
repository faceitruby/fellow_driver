class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :check_authorize, only: [:create]

  respond_to :json

  # POST api/users/signup
  def create
    result = Users::RegistrationService.new(params).call
    result.success? ? render_success_response(result.data) : render_error_response(result.errors)
  end
end
