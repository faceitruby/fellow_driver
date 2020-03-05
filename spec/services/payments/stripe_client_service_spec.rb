# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::StripeClientService do
  context 'when payment info correct' do
    it { expect(payment_stub.call.class).to eq(OpenStruct) }
    it { expect(payment_stub.call.data).to eq({type: 'card', id: 'pm_qwe'}) }
    it { expect(payment_stub.call.success?).to be true }
    it { expect(payment_stub.call.errors).to eq(nil) }
  end

  context 'when payment not correct' do
    it { expect(no_payment_stub.call.class).to eq(OpenStruct) }
    it { expect(no_payment_stub.call.success?).to be false }
    it { expect(no_payment_stub.call.errors).to eq('Invalid card info') }
    it { expect(no_payment_stub.call.data).to eq(nil) }
  end
end

def payment_stub
  returned = [{
    'id'=> 'pm_qwe',
    'type'=> 'card'
  }]
  payment_service = Payments::StripeClientService.new
  allow(payment_service).to receive(:stripe_payment_method).and_return(returned)
  payment_service
end

def no_payment_stub
  error_body = {
    error: {
      message: 'Invalid card info'
    }
  } 
  error = Stripe::InvalidRequestError.new('', '', http_status: 400, http_body: 'ibody', json_body: error_body)
  payment_service = Payments::StripeClientService.new
  allow(payment_service).to receive(:stripe_payment_method).and_raise(error)
  payment_service
end
