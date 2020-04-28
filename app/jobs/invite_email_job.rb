# frozen_string_literal: true

class InviteEmailJob
  @queue = :invite_email

  def self.perform(name, user_receiver, url)
    UserMailer.invite_email(name, user_receiver, url).deliver
  end
end
