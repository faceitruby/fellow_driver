# frozen_string_literal: true

class Users::InvitationsController < ApplicationController
  skip_before_action :check_authorize

  def create
    result = Users::InvitationService.perform(
        invite_params.merge(current_user: current_user)
    )
    if result.success?
      render_success_response(result.data, :created)
    else
      render_error_response(result.errors)
    end
  end

  def update
    user = User.accept_invitation!(accept_invitation_params)
    if user.errors.empty?
      render_success_response({ user: user.present.invite_page_context },
                              :accepted)
    else
      render_error_response(user.errors, :unprocessable_entity)
    end
  end

  private

  def invite_params
    params.permit(:avatar,
                  :first_name,
                  :last_name,
                  :email,
                  :phone,
                  :member_type,
                  :skip_invitation)
  end

  def accept_invitation_params
    params.permit(:avatar,
                  :address,
                  :email,
                  :phone,
                  :password,
                  :password_confirmation,
                  :invitation_token)
  end
end
