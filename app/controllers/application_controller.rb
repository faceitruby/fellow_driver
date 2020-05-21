# frozen_string_literal: true

require 'json_web_token'

class ApplicationController < ActionController::API
  EXCEPTIONS = %w[ActiveRecord::RecordNotUnique
                  ActiveRecord::RecordInvalid
                  ActiveRecord::RecordNotFound
                  ActiveRecord::RecordNotDestroyed
                  Koala::Facebook::AuthenticationError
                  Koala::Facebook::ClientError
                  Stripe::InvalidRequestError
                  Stripe::APIConnectionError
                  ActionController::InvalidAuthenticityToken
                  KoalaError
                  JWT::DecodeError
                  Twilio::REST::TwilioError
                  Users::AddressAutocompleteService::OverQuotaLimitError
                  Users::AddressAutocompleteService::UnknownError
                  StandardError].freeze

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_authorize

  rescue_from(*EXCEPTIONS, with: :exception_handler)

  protected

  def render_response(json)
    render json: json, code: 200
  end

  def render_success_response(data = {}, status = :ok)
    response = { success: true }
    response.merge! data if data.present?
    render json: response, status: status
  end

  def render_error_response(message = 'Bad Request', status = :bad_request)
    render json: { success: false, error: message }, status: status
  end

  def configure_permitted_parameters
    added_attrs = %i[phone email password password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def check_authorize
    token = request.headers['token']
    raise Warden::NotAuthenticated, 'Token is missing' if token.blank?

    user = JsonWebToken.decode(token)
    raise ActionController::InvalidAuthenticityToken, 'Token is not valid' if Time.current.to_i > user[:expire]
  end

  def current_user
    User.find(JsonWebToken.decode(request.headers['token'])[:user_id])
  rescue ActiveRecord::RecordNotFound
    raise ActionController::InvalidAuthenticityToken, 'No one user matches this token'
  end

  def exception_handler(exception)
    render_error_response(*ParseExceptionService.perform(exception: exception).values)
  end
end
