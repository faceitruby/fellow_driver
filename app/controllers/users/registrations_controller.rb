# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST api/users/signup
  def create
    result = Users::RegistrationService.new(params).execute
    result.success? ? render_success_response : render_error_response(result.errors)
  end
end
