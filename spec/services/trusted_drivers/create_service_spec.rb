# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'trusted_driver_create' do

  it { expect(subject.class).to eq(OpenStruct) }
  it { expect(subject.success?).to be success }
  it { expect { subject }.to change(TrustedDriver, :count).by(change_count) }
end

RSpec.describe TrustedDrivers::CreateService do
  let(:trusted_driver_request) { create(:trusted_driver_request) }

  context 'when params valid' do
    subject { TrustedDrivers::CreateService.perform(trusted_driver_request: trusted_driver_request, current_user: trusted_driver_request.receiver) }
    let(:success) { true }
    let(:change_count) { 1 }

    it { expect(subject.errors).to eq(nil) }
    it_behaves_like 'trusted_driver_create'
  end

  context 'when params not valid' do
    subject { TrustedDrivers::CreateService.perform(trusted_driver_request: nil, current_user: trusted_driver_request.receiver) }
    let(:success) { false }
    let(:change_count) { 0 }

    it { expect(subject.errors).to_not eq(nil) }
    it_behaves_like 'trusted_driver_create'
  end
end
