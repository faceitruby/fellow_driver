# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :check_authorize, only: [:create]
  skip_before_action :authenticate_scope!, only: [:update]

  respond_to :json

  # POST api/users/signup
  def create
    result = Users::Registration::CreateService.perform(create_registration_params)
    result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors, 422)
  end

  def update
    result = Users::Registration::UpdateService.perform(update_registration_params)
    result.success? ? render_success_response(result.data, :no_content) : render_error_response(result.errors, 422)
  end

  private

  def create_registration_params
    params.require(:user).permit(:email, :phone, :password)
  end

  def update_registration_params
    permitted = params.require(:user).permit(:email, :phone, :password, :first_name,
                                             :last_name, :address, :avatar)
    permitted.merge(token: request.headers['token']) if request.headers['token']
  end
end
