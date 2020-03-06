# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentPresenter do
  let(:payment) { build(:payment) }

  describe 'MODEL_ATTRIBUTES constant' do
    subject { described_class::MODEL_ATTRIBUTES }
    it { is_expected.to eq %i[payment_type user_payment] }
  end

  describe '#page_content' do
    subject { described_class.new(payment).payments_page_context }

    it { is_expected.to be_instance_of String }
    it 'returns JSON compatible string' do
      expect(JSON.parse(subject)).to be_present
    end

    let(:returned) do
      {
        payment_type: payment.payment_type,
        user_payment: payment.user_payment,
      }.to_json
    end

    it 'returns JSON compatible string' do
      expect(subject).to eq(returned)
    end
  end

  describe 'delegates' do
    subject { described_class.new(payment) }

    PaymentPresenter::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
