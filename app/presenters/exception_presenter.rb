# frozen_string_literal: true

# class for retrieve hash with params
class ExceptionPresenter
  EXCEPTIONS_WITH_STATUS_422 = [ActiveRecord::RecordNotUnique,
                                ActiveRecord::RecordInvalid,
                                ActiveRecord::RecordNotFound,
                                ArgumentError,
                                Users::AddressAutocompleteService::OverQuotaLimitError,
                                Users::AddressAutocompleteService::UnknownError].freeze

  def initialize(exception)
    @exception = exception
  end

  attr_reader :exception

  def page_context
    exception_parser
  end

  private

  def exception_parser
    case exception
    when *EXCEPTIONS_WITH_STATUS_422
      { message: exception.message, status: :unprocessable_entity }
    when Koala::Facebook::AuthenticationError, Warden::NotAuthenticated, ActionController::InvalidAuthenticityToken
      { message: exception.message, status: :unauthorized }
    when JWT::DecodeError
      { message: 'Token is not valid', status: :unprocessable_entity }
    else
      { message: exception.message, status: :bad_request }
    end
  end
end
