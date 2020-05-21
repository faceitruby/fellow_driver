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
    subject { described_class.perform }

    before do
      allow_any_instance_of(described_class).to receive(:stripe_payment_method).and_return(response)
    end

    it { expect(subject).to eq(response.first) }
    it { expect { subject }.to_not raise_error }
  end

  context 'when payment not correct' do
    let(:error_body) { { error: { message: 'Invalid card info' } } }
    let(:error) { Stripe::InvalidRequestError.new('', '', http_status: 400, http_body: 'ibody', json_body: error_body) }
    subject { described_class.perform }

    before do
      allow_any_instance_of(described_class).to receive(:stripe_payment_method).and_raise(error)
    end

    it { expect { subject }.to raise_error Stripe::InvalidRequestError }
  end
end
