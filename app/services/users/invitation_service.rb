# frozen_string_literal: true

module Users
  class InvitationService < ApplicationService
    # @attr_reader params [Hash]
    # - first_name: [String] new user first name
    # - last_name: [String] new user last name
    # - phone: [string] new user phone number
    # - email: [string] new user email
    # - member_type: [integer] user relationship
    # - current_user: [User] Current user

    def call
      invite = User.invite!(invite_params, current_user) { |u| u.skip_invitation = true }
      raise ActiveRecord::RecordInvalid, invite if invite.errors.any?

      Resque.enqueue(InvitePhoneJob, params[:phone], message(invite))
      FamilyMembers::EmailMessenger.perform(email_params(invite)) if invite.email
      invite
    end

    private

    def message(invite)
      <<~MSG
        #{current_user.name} added you as family
        member on FellowDriver. Click the link below to accept the invitation:
        http://localhost:3000/api/users/invitation/accept?invitation_token=#{invite.raw_invitation_token}
      MSG
    end

    def invite_params
      params.permit(:first_name,
                    :last_name,
                    :phone,
                    :email,
                    :member_type).merge(family_id: current_user.family.id)
    end

    def phone_params(invite)
      {
        body: message(invite),
        phone: params[:phone].presence
      }
    end

    def email_params(invite)
      {
        user_receiver: invite,
        current_user: current_user
      }
    end
  end
end
