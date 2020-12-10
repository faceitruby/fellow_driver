# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Connections::FamilyConnections::UpdateService do
  let(:requestor_user) { create(:user) }
  let(:receiver_user) { create(:user) }
  let(:connection) { create(:family_connection, requestor_user: requestor_user, receiver_user: receiver_user) }
  subject { described_class.perform(connection: connection) }

  describe '#call' do
    context 'performs connection' do
      it { expect(subject.class).to eq(FamilyConnection) }
      it { expect(subject.requestor_user_id).to eq(requestor_user.id) }
      it { expect(subject.receiver_user_id).to eq(receiver_user.id) }
      it { expect { subject }.to_not raise_error }
      it { expect { subject }.to change(connection, :accepted).from(false).to(true) }
    end
  end

  describe 'raise error' do
    subject { described_class.perform(connection: nil) }

    context 'when connection is missing' do
      it { expect { subject }.to raise_error ArgumentError }
    end
  end
end
