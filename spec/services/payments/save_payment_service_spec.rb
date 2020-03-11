# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::SavePaymentService do
  let(:save_payment_params) do
    {
      pm_id: 'pm_qwe',
      type: 'card',
    }
  end
  let(:user) { create(:user) }
  subject { Payments::SavePaymentService.perform(save_payment_params.merge(user: user)) }
  it { expect(subject.class).to eq(Payment) }
  it { expect { subject }.to change(Payment, :count).by(1) }
end
