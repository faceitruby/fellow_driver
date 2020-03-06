# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::SavePaymentService do
  let(:save_payment_params) do
    {
      pm_id: 'pm_qwe',
      type: 'card',
      user: create(:user)
    }
  end
  subject { Payments::SavePaymentService.new(save_payment_params).call }
  it { expect(subject.class).to eq(Payment) }
  it { expect { subject }.to change(Payment, :count).by(1) }
end
