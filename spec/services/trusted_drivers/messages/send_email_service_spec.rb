# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::Messages::SendEmailService do
  let(:requestor) { create(:user) }
  let(:receiver) { create(:user) }
  let(:params) { { current_user: requestor, user_receiver: receiver } }

  before do
    allow_any_instance_of(described_class).to receive(:url).and_return('url')
    allow_any_instance_of(Resque).to receive(:enqueue).with(InviteEmailJob, requestor.name, receiver, 'url')
  end

  subject { described_class.perform(params) }

  describe '#call' do
    it { expect(subject).to eq(nil) }
  end
end
