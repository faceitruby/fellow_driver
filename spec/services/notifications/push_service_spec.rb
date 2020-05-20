# frozen_string_literal: true

require 'rails_helper'
# OpenStruct returned from services
RSpec.shared_examples 'PushService with wrong params' do
  it 'raise ArgumentError without creating Rpush::Gcm::Notification' do
    expect { subject }.to raise_error(ArgumentError, 'The list of devices must be filled')
      .and change(Rpush::Gcm::Notification, :count).by(0)
  end
end

RSpec.describe Notifications::PushService do
  let(:notification) { create(:notification) }
  let(:registration_ids) { ['1'] }
  let(:params) do
    {
      notification: notification,
      registration_ids: registration_ids
    }
  end

  subject { described_class.perform(params) }

  describe '#call' do
    context 'when valid params' do
      it { expect { subject }.to change(Rpush::Gcm::Notification, :count).by(1) }
    end

    context 'when registration ids empty' do
      let(:registration_ids) { [] }

      it_behaves_like 'PushService with wrong params'
    end

    context 'when registration ids nil' do
      let(:registration_ids) { nil }

      it_behaves_like 'PushService with wrong params'
    end
  end
end
