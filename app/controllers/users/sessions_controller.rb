# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_signed_out_user, only: :destroy
    before_action :verify_create_params!, only: :create
    before_action -> { authenticate_user!(force: true) }

    # POST api/users/login
    def create
      render_success_response
    end

    # DELETE api/users/logout
    def destroy
      render json: { success: RevokeTokenService.perform(revoke_params) }
    end

    private

    def revoke_params
      { current_user: current_user }
    end

    def verify_create_params!
      raise ArgumentError, 'Login is missing' if params['user']&.slice(:login, :email, :phone).blank?
      raise ArgumentError, 'Password is missing' if params['user']['password'].blank?
    end
  end
end
