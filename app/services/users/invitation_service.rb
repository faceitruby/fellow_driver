# frozen_string_literal: true

module Users
  class InvitationService < ApplicationService
    def call
      invite = User.invite!(invite_params) { |u| u.skip_invitation = true }
      if invite.errors.empty?
        invite.create_family(family_params.merge(owner: current_user.id))
        invite.update(family_id: invite.family.id, invited_by_id: current_user.id)
        p "="*20, invite.raw_invitation_token, "="*20   #for testing
        message = "#{current_user['first_name']} #{current_user['last_name']} added you as family
        member on FellowDriver. Click the link below to accept the invitation: \
        http://localhost:3000/api/users/invitation/accept?invitation_token=#{invite.raw_invitation_token}"
        # TwilioTextMessenger.perform(message)
        return OpenStruct.new(success?: true,
                              data: { user: invite.present.invite_page_context },
                              errors: nil)
      else
        return OpenStruct.new(success?: false, data: nil, errors: invite.errors)
      end
    end

    private

    def invite_params
      params.permit(:email, :phone, :skip_invitation)
    end

    def family_params
      params.permit(:member_type)
    end

    def current_user
      params[:current_user].presence
    end
  end
end
