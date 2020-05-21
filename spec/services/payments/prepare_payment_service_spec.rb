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

  subject { described_class.perform(payment_params.merge(user: user)) }

  context 'when payment success created' do
    let(:response) { { 'type' => 'card', 'id' => 'pm_23eq' } }

    it { expect(subject).to be_instance_of Payment }
  end

  context 'when payment not created' do
    let(:response) { { 'type' => 'card', 'id' => 'pm_23eq' } }

    before { allow(Payments::SavePaymentService).to receive(:perform).and_raise(ActiveRecord::RecordInvalid) }

    it { expect(subject_ignore_exceptions).to be nil }
  end
end
