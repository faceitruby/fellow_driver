# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_authorize

  protected

  def render_response(json)
    render json: json, code: 200
  end

  def render_success_response(data = nil, status = :ok)
    render json: {
      success: true,
      data: data
    }, status: status
  end

  def render_error_response(message = 'Bad Request', status = :bad_request)
    render json: {
      success: false,
      message: message,
      data: nil
    }, status: status
  end

  def configure_permitted_parameters
    added_attrs = %i[phone email password password_confirmation]
    added_attrs2 = %i[phone email password password_confirmation avatar]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def check_authorize
    token = request.headers['token']
    return render_error_response unless token

    user = JsonWebToken.decode(token)
    render_error_response('Token is not valid.') if Time.now.to_i > user[:expire]
  end
end
