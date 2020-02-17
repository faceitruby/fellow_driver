# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :check_authorize, only: [:create]

  respond_to :json

  # POST api/users/signup
  def create
    result = Users::RegistrationService.new(registration_params).call
    result.success? ? render_success_response(result.data) : render_error_response(result.errors)
  end

  private

  def registration_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation)
  end
end
