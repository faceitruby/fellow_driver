# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::CreateService do
  let(:params) do
    {
      trusted_driver_request: trusted_driver_request,
      current_user: trusted_driver_request.receiver
    }
  end
  let(:trusted_driver_request) { create(:trusted_driver_request) }
  subject { described_class.perform(params) }

  describe '#call' do
    context 'when params valid' do
      it { expect { subject }.to change(TrustedDriver, :count) }
      it { expect { subject }.to change(trusted_driver_request, :accepted).to true }
      it { is_expected.to be_instance_of TrustedDriver }
      it { expect { subject }.to_not raise_error }
    end

    %i[trusted_driver_request current_user].each do |param|
      context "when #{param} is nil" do
        let(:params) { super().merge(param => nil) }

        it { expect { subject_ignore_exceptions }.to_not change(TrustedDriver, :count) }
        it { expect { subject_ignore_exceptions }.to_not change(trusted_driver_request, :accepted) }
        it('returns nil') { expect(subject_ignore_exceptions).to be nil }
        it { expect { subject }.to raise_error ArgumentError }
      end
    end

    context 'when TrustDriver creating failed' do
      before { allow(TrustedDriver).to receive(:create!).and_raise(ActiveRecord::RecordInvalid) }

      it { expect { subject_ignore_exceptions }.to_not change(TrustedDriver, :count) }
      it do
        expect do
          subject_ignore_exceptions
          trusted_driver_request.reload
        end.to_not change(trusted_driver_request, :accepted)
      end
      it('returns nil') { expect(subject_ignore_exceptions).to be nil }
      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
    end

    context 'when TrustDriverRequest updating failed' do
      before { allow_any_instance_of(TrustedDriverRequest).to receive(:update!).and_raise ActiveRecord::RecordInvalid }

      it { expect { subject_ignore_exceptions }.to_not change(TrustedDriver, :count) }
      it { expect { subject_ignore_exceptions }.to_not change(trusted_driver_request, :accepted) }
      it('returns nil') { expect(subject_ignore_exceptions).to be nil }
      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
    end
  end
end
