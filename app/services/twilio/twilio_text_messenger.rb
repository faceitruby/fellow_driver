# frozen_string_literal: true

module Twilio
  class TwilioTextMessenger < ApplicationService
    # @attr_reader params [Hash]
    # - body: [String] Message text
    # - phone: [String] Phone number

    def call
      twilio_client.messages.create({
                                      from: ENV['twilio_phone_number'],
                                      to: phone,
                                      body: message
                                    })
    end

    private

    def twilio_client
      @twilio_client ||= Twilio::REST::Client.new
    end

    def message
      params[:body].presence
    end

    def phone
      params[:phone].presence
    end
  end
end
