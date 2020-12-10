# frozen_string_literal: true

module Users
  class InvitationsController < ApplicationController
    skip_before_action :authenticate_user!, only: :update

    def create
      if receiver_user.present?
        result = Connections::FamilyConnections::CreateService.perform(family_connection_params)
        render_success_response({ connection: result }, :created)
      else
        user = Users::InvitationService.perform(invite_params.merge(current_user: current_user))
        render_success_response({ invite_token: user.raw_invitation_token, user: user.present.page_context }, :created)
      end
    end

    def update
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
                                   :birthday,
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

    def family_connection_params
      params.require(:user).permit(:member_type)
            .merge(requestor_user: current_user,
                   receiver_user: receiver_user)
    end

    def receiver_user
      @receiver_user ||= User.where('phone = :phone or email = :email', { phone: params[:user][:phone],
                                                                          email: params[:user][:email] }).first
    end
  end
end
