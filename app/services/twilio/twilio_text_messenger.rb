# frozen_string_literal: true

module Twilio
  class TwilioTextMessenger < ApplicationService
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def call
      client = Twilio::REST::Client.new
      client.messages.create({
        from: ENV['twilio_phone_number'],
        to: '+111111111111',
        body: message
      })
    end
  end
end
