# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::SavePaymentService do
  let(:payment_params) do
    {
      pm_id: 'pm_qwe',
      type: 'card'
    }
  end
  let(:user) { create(:user) }
  subject { described_class.perform(payment_params.merge(user: user)) }

  context 'when all fields provided' do
    it { is_expected.to be_instance_of Payment }
    it { expect { subject }.to change(Payment, :count).by(1) }
    it { expect { subject }.to_not raise_error }
  end

  %i[pm_id type].each do |param|
    context "when #{param} is nil" do
      let(:payment_params) { super().merge(param => nil) }

      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
      it { expect { subject_ignore_exceptions }.to_not change(Payment, :count) }
    end
  end
end
