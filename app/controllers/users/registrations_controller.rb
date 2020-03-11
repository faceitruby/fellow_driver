# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :check_authorize, only: :create
    skip_before_action :authenticate_scope!, only: :update

    respond_to :json

    # POST api/users/signup
    def create
      result = Users::Registration::CreateService.perform(create_params)
      result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors, 422)
    end

    # PUT|PATCH api/users/signup
    def update
      result = Users::Registration::UpdateService.perform(update_params)
      result.success? ? render_success_response(result.data, :no_content) : render_error_response(result.errors, 422)
    end

    private

    def create_params
      params.require(:user).permit(:email, :phone, :password, :login)
    end

    def update_params
      permitted = params.require(:user).permit(:email, :phone, :password, :first_name,
                                               :last_name, :address, :avatar)
      permitted.merge!(token: request.headers['token']) if request.headers['token']
      permitted
    end
  end
end
