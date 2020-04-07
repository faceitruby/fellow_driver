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
      @invite = User.invite!(invite_params) { |u| u.skip_invitation = true }
      if @invite.errors.empty?
        @invite.update_columns(family_id: current_user.family.id,
                              invited_by_id: current_user.id)
        @message = "#{current_user['first_name']} #{current_user['last_name']} added you as family\
        member on FellowDriver. Click the link below to accept the invitation:\
        http://localhost:3000/api/users/invitation/accept?invitation_token=#{@invite.raw_invitation_token}"
        Twilio::TwilioTextMessenger.perform(twilio_params)
        return OpenStruct.new(success?: true,
                              data: { invite_token: @invite.raw_invitation_token,
                                      user: @invite.present.page_context },
                              errors: nil)
      else
        return OpenStruct.new(success?: false, data: nil, errors: @invite.errors)
      end
    end

    private

    def invite_params
      params.except(:current_user)
    end

    def twilio_params
      {
          body: @message,
          phone: @invite.phone
      }
    end
  end
end
