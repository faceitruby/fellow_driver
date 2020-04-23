# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::Requests::DeleteService do
  let(:trusted_driver_request) { create(:trusted_driver_request) }
  let(:params) { { trusted_driver_request: trusted_driver_request } }

  subject { described_class.perform(params) }

  describe '#call' do
    let(:message) { { message: 'deleted' } }

    it { expect(subject.data).to eq(message) }
    it { expect(subject.errors).to eq(nil) }
    it { expect(subject.success?).to be true }
  end
end
