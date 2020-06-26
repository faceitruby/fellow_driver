# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :check_authorize, only: %i[create]
    skip_before_action :verify_signed_out_user

    respond_to :json

    # POST api/users/login
    def create
      token = Users::SessionService.perform(user: warden.authenticate)

      render_success_response({ token: token }, :ok)
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
