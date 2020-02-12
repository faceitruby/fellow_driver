class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    result = Users::OmniauthFacebookService.new(params[:token]).execute
    result.success? ? render_success_response : render_error_response(result.errors)
  end
end