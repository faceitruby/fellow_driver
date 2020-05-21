# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::Requests::DeleteService do
  let(:params) { { trusted_driver_request: trusted_driver_request } }
  subject { described_class.perform(params) }

  describe '#call' do
    context 'when TrustedDriverRequest exists' do
      let!(:trusted_driver_request) { create(:trusted_driver_request) }

      it('returns true') { is_expected.to eq true }
      it { expect { subject }.to_not raise_error }
      it { expect { subject }.to change(TrustedDriverRequest, :count).by(-1) }
    end

    context 'when TrustedDriverRequest doesn\'t provided' do
      let!(:trusted_driver_request) { nil }

      it('returns nil') { expect(subject_ignore_exceptions).to be nil }
      it { expect { subject }.to raise_error ActiveRecord::RecordNotFound }
      it { expect { subject_ignore_exceptions }.to_not change(TrustedDriverRequest, :count) }
    end

    context 'when TrustedDriverRequest is already deleted' do
      let!(:trusted_driver_request) { create(:trusted_driver_request) }

      before { trusted_driver_request.destroy }

      it('returns true') { is_expected.to eq true }
      it { expect { subject }.to_not raise_error }
      it { expect { subject }.to_not change(TrustedDriverRequest, :count) }
    end
  end
end
