# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::StripeClientService do
  context 'when payment info correct' do
    let(:returned) do
      [{
        'id'=> 'pm_qwe',
        'type'=> 'card'
      }]
    end

    subject do
      payment_service = Payments::StripeClientService.new
      allow(payment_service).to receive(:stripe_payment_method).and_return(returned)
      payment_service
    end
    it { expect(subject.call.class).to eq(OpenStruct) }
    it { expect(subject.call.data).to eq({type: 'card', id: 'pm_qwe'}) }
    it { expect(subject.call.success?).to be true }
    it { expect(subject.call.errors).to eq(nil) }
  end

  context 'when payment not correct' do
    let(:error_body) do
      {
        error: {
          message: 'Invalid card info'
        }
      } 
    end
    let(:error) { Stripe::InvalidRequestError.new('', '', http_status: 400, http_body: 'ibody', json_body: error_body) }
    
    subject do
      payment_service = Payments::StripeClientService.new
      allow(payment_service).to receive(:stripe_payment_method).
      and_raise(error)
      payment_service
    end

    it { expect(subject.call.class).to eq(OpenStruct) }
    it { expect(subject.call.success?).to be false }
    it { expect(subject.call.errors).to eq('Invalid card info') }
    it { expect(subject.call.data).to eq(nil) }
  end
end
