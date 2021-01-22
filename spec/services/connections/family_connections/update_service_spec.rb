# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Connections::FamilyConnections::UpdateService do
  let(:requestor_user) { create(:user) }
  let(:user) { create(:user, email: 'user@example.com') }
  let(:family_connection) { create(:family_connection, requestor_user: requestor_user, receiver_user: user) }
  let(:params) do
    { id: family_connection&.id,
      current_user: user }
  end

  subject { described_class.perform(params) }

  describe '#call' do
    context 'performs connection' do
      it { expect { subject }.to_not raise_error }
      it { expect { subject }.to change { family_connection.reload.accepted }.from(false).to(true) }
      it { expect { subject }.to change(user, :member_type).from(user.member_type).to(family_connection.member_type) }
      it { expect { subject }.to change { user.reload.family_id }.from(user.family_id).to(requestor_user.family_id) }
    end
  end

  describe 'raise error' do
    %i[family_connection user].each do |field|
      let(field.to_sym) { nil }

      it { expect { subject }.to raise_error ArgumentError }
    end
  end
end
