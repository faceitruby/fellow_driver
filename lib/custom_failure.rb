# frozen_string_literal: true

class CustomFailureApp < Devise::FailureApp
  def respond
    json_error_response
  end

  def json_error_response
    self.status = :unauthorized
    self.content_type = 'application/json'
    self.response_body = { success: false, error: i18n_message }.to_json
  end
end
