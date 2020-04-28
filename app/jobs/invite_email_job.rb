# frozen_string_literal: true

class InviteEmailJob
  @queue = :invite_email

  def self.perform(current_user, user_receiver, url)
    UserMailer.invite_email(current_user, user_receiver, url).deliver
  end
end
