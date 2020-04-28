# frozen_string_literal: true

module Users
  class InvitationService < ApplicationService
    # @attr_reader params [Hash]
    # - first_name: [String] new user first name
    # - last_name: [String] new user last name
    # - phone: [string] new user phone number
    # - member_type: [integer] user relationship
    # - current_user: [User] Current user

    def call
      invite = User.invite!(invite_params) { |u| u.skip_invitation = true }
      if invite.errors.empty?
        update_fields(invite)
        Resque.enqueue(InvitePhoneJob, params[:phone], message(invite))
        FamilyMembers::EmailMessenger.perform(email_params(invite)) if invite.email
        OpenStruct.new(success?: true,
                       data: { invite_token: invite.raw_invitation_token,
                               user: invite },
                       errors: nil)
      else
        OpenStruct.new(success?: false, data: nil, errors: invite.errors)
      end
    end

    private

    def update_fields(invite)
      invite.update_columns(family_id: current_user.family.id,
                            invited_by_id: current_user.id)
    end

    def message(invite)
      <<~MSG
        #{current_user.name} added you as family
        member on FellowDriver. Click the link below to accept the invitation:
        http://localhost:3000/api/users/invitation/accept?invitation_token=#{invite.raw_invitation_token}
      MSG
    end

    def invite_params
      params.except(:current_user)
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
