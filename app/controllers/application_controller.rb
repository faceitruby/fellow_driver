# frozen_string_literal: true

require 'json_web_token'

class ApplicationController < ActionController::API
  EXCEPTIONS = %w[ActiveRecord::RecordNotUnique
                  ActiveRecord::RecordInvalid
                  ActiveRecord::RecordNotFound
                  ActiveRecord::RecordNotDestroyed
                  ArgumentError
                  Warden::NotAuthenticated
                  Koala::Facebook::AuthenticationError
                  Koala::Facebook::ClientError
                  Stripe::InvalidRequestError
                  Stripe::APIConnectionError
                  ActionController::InvalidAuthenticityToken
                  Koala::KoalaError
                  JWT::DecodeError
                  Twilio::REST::TwilioError
                  Users::AddressAutocompleteService::OverQuotaLimitError
                  Users::AddressAutocompleteService::UnknownError
                  StandardError].freeze

  before_action :authenticate_user!
  respond_to :json

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

  def exception_handler(exception)
    render_error_response(*ExceptionPresenter.new(exception).page_context.values)
  end
end
