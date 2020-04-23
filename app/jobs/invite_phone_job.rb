# frozen_string_literal: true

class InvitePhoneJob
  @queue = :invite_sms

  def self.perform(phone, message)
    Twilio::TwilioTextMessenger.perform(phone: phone, body: message)
  end
end
