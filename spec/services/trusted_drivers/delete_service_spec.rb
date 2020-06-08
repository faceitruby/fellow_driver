# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::DeleteService do
  let(:params) { { trusted_driver: trusted_driver } }
  subject { described_class.perform(params) }

  describe '#call' do
    context 'when trusted_driver exists' do
      let!(:trusted_driver) { create(:trusted_driver) }

      it { expect { subject }.to change(TrustedDriver, :count).by(-1) }
      it { expect { subject }.to_not raise_error }
      it { expect(subject.destroyed?).to be true }
    end

    context 'when trusted_driver doesn\' exist' do
      let!(:trusted_driver) { nil }

      it { expect { subject_ignore_exceptions }.to_not change(TrustedDriver, :count) }
      it { expect { subject }.to raise_error ActiveRecord::RecordNotFound, 'Trusted driver not found' }
    end
  end
end
