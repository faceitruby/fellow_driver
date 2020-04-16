# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::StripeClientService do
  context 'when payment info correct' do
    let(:response) do
      [{
        'id' => 'pm_qwe',
        'type' => 'card'
      }]
    end

    before do
      allow_any_instance_of(described_class).to receive(:stripe_payment_method).and_return(response)
    end

    subject { described_class.perform }

    let(:service_response) { { type: 'card', id: 'pm_qwe' } }
    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.data).to eq(service_response) }
    it { expect(subject.success?).to be true }
    it { expect(subject.errors).to eq(nil) }
  end

  context 'when payment not correct' do
    let(:error_body) { { error: { message: 'Invalid card info' } } }
    let(:error) { Stripe::InvalidRequestError.new('', '', http_status: 400, http_body: 'ibody', json_body: error_body) }

    before do
      allow_any_instance_of(described_class).to receive(:stripe_payment_method).and_raise(error)
    end

    subject do
      described_class.perform
    end
    let(:error_message) { 'Invalid card info' }
    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.success?).to be false }
    it { expect(subject.errors).to eq(error_message) }
    it { expect(subject.data).to eq(nil) }
  end
end
