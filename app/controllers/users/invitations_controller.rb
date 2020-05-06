# frozen_string_literal: true

module Users
  class InvitationsController < ApplicationController
    skip_before_action :check_authorize, only: :update

    def create
      result = Users::InvitationService.perform(invite_params.merge(current_user: current_user))
      if result.success?
        render_success_response(result.data, :created)
      else
        render_error_response(result.errors)
      end
    end

    def update
      result = FamilyMembers::AcceptInvitation.perform(accept_invitation_params)
      if result.errors.empty?
        render_success_response({ user: result }, :accepted)
      else
        render_error_response(result.errors, :unprocessable_entity)
      end
    end

    private

    def invite_params
      params.require(:user).permit(:avatar,
                                   :first_name,
                                   :last_name,
                                   :email,
                                   :phone,
                                   :member_type,
                                   :skip_invitation)
    end

    def accept_invitation_params
      params.require(:user).permit(:avatar,
                                   :address,
                                   :email,
                                   :phone,
                                   :password,
                                   :password_confirmation,
                                   :invitation_token)
    end
  end
end
