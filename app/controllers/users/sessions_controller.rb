# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :check_authorize, only: %i[create]
    skip_before_action :verify_signed_out_user

    respond_to :json

    # POST api/users/login
    def create
      # byebug
      result = Users::SessionService.perform(user: warden.authenticate)
      result.success? ? render_success_response(result.data) : render_error_response(result.errors, 422)
    end

    # GET /resource/sign_out
    # def destroy
    #   # jwt_encode(current_user)
    #   # render json: {'overiden': 'yes'}
    #   # resource.deactivated_at = DateTime.now
    #   # resource.save!
    #   # Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    #   # # render_response(warden.logout)
    # end
  end
end
