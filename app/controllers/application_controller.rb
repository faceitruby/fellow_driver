class ApplicationController < ActionController::API
  before_action :skip_session

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

  # Skip sessions and cookies for Rails API
  def skip_session
    request.session_options[:skip] = true
  end
end
