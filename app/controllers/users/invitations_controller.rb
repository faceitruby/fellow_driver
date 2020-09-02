# frozen_string_literal: true

module Users
  class InvitationsController < ApplicationController

    skip_before_action :authenticate_user!, only: :update


    def create
      user = Users::InvitationService.perform(invite_params.merge(current_user: current_user))

      render_success_response({ invite_token: user.raw_invitation_token, user: user.present.page_context }, :created)
    end

    def update

      # result = FamilyMembers::AcceptInvitation.perform(accept_invitation_params)
      # if result.errors.empty?
      #   render_success_response({ user: result }, :accepted)
      # else
      #   render_error_response(result.errors, :unprocessable_entity)
      # end

      user = User.accept_invitation!(accept_invitation_params)
      raise ActiveRecord::RecordInvalid, user if user.errors.any?

      render_success_response({ user: user.present.page_context }, :accepted)

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
