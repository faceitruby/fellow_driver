# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::SavePaymentService do
  subject { Payments::SavePaymentService.new(save_payment_params).call }
  it { expect(subject.class).to eq(Payment) }
  it { expect { subject }.to change(Payment, :count).by(1) }
end

def save_payment_params
  card_param = {
    pm_id: 'pm_qwe',
    type: 'card',
  }
  card_param.merge(user: create(:user))
end
