# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::PreparePaymentService do
  let(:user) { create(:user) }
  let(:payment_params) do
    {
      type: 'card',
      card: {
        number: Faker::Number.number(digits: 16),
        exp_month: Faker::Number.number(digits: 1),
        exp_year: Faker::Number.number(digits: 4),
        cvc: Faker::Number.number(digits: 3)
      }
    }
  end

  before do
    allow_any_instance_of(described_class).to receive(:create_payment).and_return(response)
  end

  subject do
    described_class.perform(payment_params.merge(user: user))
  end

  context 'when payment success created' do
    let(:response) { OpenStruct.new(success?: true, data: { type: 'card', id: 'pm_23eq' }, errors: nil) }
    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.success?).to be true }
    it { expect(subject.data.class).to eq(Payment) }
    it { expect(subject.errors).to eq(nil) }
  end

  context 'when payment not created' do
    let(:response) { OpenStruct.new(success?: false, response: nil, errors: 'Erorr message') }

    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.success?).to be false }
    it { expect(subject.response).to eq(nil) }
    it { expect(subject.errors).to eq('Erorr message') }
  end
end
