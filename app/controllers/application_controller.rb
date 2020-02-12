class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def render_response(json)
    render json: json, code: 200
  end

  def render_success_response(data = nil, msg = 'Ok')
    render json: {
        success: true,
        message: msg,
        data: data
    }, code: 200
  end

  def render_error_response(msg = 'Bad Request', code = 400)
    render json: {
        success: false,
        message: msg,
        data: nil
    }, code: code
  end

  def configure_permitted_parameters
    added_attrs = [:phone, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end
