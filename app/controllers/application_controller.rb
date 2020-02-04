class ApplicationController < ActionController::Base
  protected

  def render_response(json)
    render json: json, code: 200
  end
end
