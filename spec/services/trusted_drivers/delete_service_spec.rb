# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::DeleteService do
  let(:trusted_driver) { create(:trusted_driver) }
  subject { TrustedDrivers::DeleteService.perform(trusted_driver: trusted_driver) }
  let(:message) { {message: 'deleted'} }

  it { expect(subject.data).to eq(message) }
  it { expect(subject.errors).to eq(nil) }
  it { expect(subject.success?).to be true }
end
