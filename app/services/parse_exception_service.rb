# frozen_string_literal: true

class ParseExceptionService < ApplicationService
  # @attr_reader params [Hash] Hash with exception
  # - exception [StandardError] Any exception inherited from StandardError

  def call
    case exception
    when ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError,
         Users::AddressAutocompleteService::OverQuotaLimitError, Users::AddressAutocompleteService::UnknownError
      { message: exception.message, status: :unprocessable_entity }
    when Koala::Facebook::AuthenticationError, Warden::NotAuthenticated, ActionController::InvalidAuthenticityToken
      { message: exception.message, status: :unauthorized }
    when JWT::DecodeError
      { message: 'Token is not valid', status: :unprocessable_entity }
    else
      { message: exception.message, status: :bad_request }
    end
  end

  private

  def exception
    params.fetch(:exception)
  end
end
