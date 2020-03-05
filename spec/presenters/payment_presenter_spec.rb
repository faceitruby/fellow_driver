# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentPresenter do
  context 'contain fields' do
    %i[payment_type user_payment].each do |field|
      it { expect(PaymentPresenter::MODEL_ATTRIBUTES).to include field }
    end
  end

  context '#payments_page_context' do
    let(:payment) { build(:payment) }
    subject { PaymentPresenter.new(payment).payments_page_context }

    it { expect(subject.class).to eq(String) }
    it 'returns JSON compatible string' do
      expect { JSON.parse subject }.to_not raise_error(JSON::ParserError)
    end
  end

  describe 'methods' do
    let(:payment) { build(:payment) }
    subject { PaymentPresenter.new(payment) }

    PaymentPresenter::MODEL_ATTRIBUTES.each do |field|
      it { is_expected.to respond_to(field) }
    end
  end
end
