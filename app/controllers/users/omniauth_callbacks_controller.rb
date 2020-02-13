class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # POST api/users/auth/facebook
  def facebook
    result = Users::OmniauthFacebookService.new(params[:token]).execute
    result.success? ? render_success_response(result.data) : render_error_response(result.errors)
  end
end