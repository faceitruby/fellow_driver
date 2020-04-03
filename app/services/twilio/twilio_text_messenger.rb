# frozen_string_literal: true

module Twilio
  class TwilioTextMessenger < ApplicationService

    def call
      client = twilio_client
      client.messages.create({
        from: ENV['twilio_phone_number'],
        to: '+111111111111',
        body: params
      })
    end

    private

    def twilio_client
      Twilio::REST::Client.new
    end
  end
end
