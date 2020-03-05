# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::PreparePaymentService do
  context 'when payment success created' do
    subject { payment_prepare_stub.call }

    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.success?).to be true }
    it { expect(subject.data.class).to eq(Payment) }
    it { expect(subject.errors).to eq(nil) }
  end

  context 'when payment not created' do
    subject { payment_prepare_stub(false).call }

    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.success?).to be false }
    it { expect(subject.response).to eq(nil) }
    it { expect(subject.errors).to eq('Erorr message') }
  end
end

def payment_prepare_params
  card_param = {
    type: 'card',
    card: {
      number: Faker::Number.number(digits: 16),
      exp_month: Faker::Number.number(digits: 1),
      exp_year: Faker::Number.number(digits: 4),
      cvc: Faker::Number.number(digits: 3)
    }
  }
  card_param.merge(user: create(:user))
end

def payment_prepare_stub(success = true)
  if success
    response = OpenStruct.new(success?: true, data: { type: 'card', id: 'pm_23eq' }, errors: nil)
  else
    response = OpenStruct.new(success?: false, response: nil, errors: 'Erorr message')
  end
  payment_service = Payments::PreparePaymentService.new(payment_prepare_params)
  allow(payment_service).to receive(:create_payment).and_return(response)
  payment_service
end
