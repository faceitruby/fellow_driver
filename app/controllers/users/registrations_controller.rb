# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # POST api/users/signup
    def create
      add_token_to_header Users::Registration::CreateService.perform(create_params)
      render_success_response(nil, :created)
    end

    # PUT|PATCH api/users/signup
    def update
      result = Users::Registration::UpdateService.perform(update_params)

      render_success_response({ user: result }, :ok)
    end

    private

    def create_params
      params.require(:user).permit(:email, :phone, :password, :login).merge(member_type: 'owner', family_attributes: {})
    end

    def update_params
      permitted = params.require(:user).permit(:email, :phone, :password, :first_name,
                                               :last_name, :address, :avatar, :birthday)
      permitted.merge!(current_user: current_user)
      permitted
    end

    def add_token_to_header(user)
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      response.set_header 'Authorization', "Bearer #{token}"
    end
  end
end
