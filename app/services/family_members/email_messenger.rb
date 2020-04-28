# frozen_string_literal: true

module FamilyMembers
  class EmailMessenger < FamilyMembers::ApplicationService
    # @attr_reader params [Hash]
    # - user_receiver: [User] new family member
    # - current_user: [User] current_user

    def call
      Resque.enqueue(InviteEmailJob, current_user, user_receiver, url)
    end

    private

    def url
      "http://#{ENV['HOST_ADDRESS']}/api/users/invitation/accept?invitation_token=#{token}"
    end

    def token
      user_receiver.raw_invitation_token
    end
  end
end
