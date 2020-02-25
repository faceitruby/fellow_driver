# frozen_string_literal: true

class TwilioTextMessenger
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def call
    client = Twilio::REST::Client.new
    client.messages.create({
      from: ENV['twilio_phone_number'],
      to: '+380676371813',
      body: message
    })
  end
end
