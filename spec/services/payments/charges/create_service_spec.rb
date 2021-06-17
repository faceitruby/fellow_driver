# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Charges::CreateService do
  describe '#call' do
    subject { described_class.perform(charge_params.merge(user: user)) }
    let(:charge_params) { { amount: 100 } }
    let(:expected_params) do
      { amount: (charge_params[:amount] * 100).to_i,
        currency: 'usd',
        customer: user.stripe_customer_id }
    end

    context 'with valid params' do
      let(:user) { create(:user, :stripe_customer) }

      before { allow(Stripe::Charge).to receive(:create) }
      after { subject }

      it { expect(Stripe::Charge).to receive(:create).once }

      it { expect(Stripe::Charge).to receive(:create).with(expected_params) }
    end

    context 'if has no customer_id' do
      let(:user) { create(:user) }

      it { expect { subject }.to raise_error(ArgumentError, 'Stripe Customer must exist!') }
    end
  end
end
