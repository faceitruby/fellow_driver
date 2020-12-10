# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Connections::FamilyConnections::CreateService do
  describe '#call' do
    let(:requestor_user) { create(:user) }
    let(:receiver_user) { create(:user) }
    let(:member_type) { User.member_types.keys.first(4).sample }
    subject do
      described_class.perform(requestor_user: requestor_user,
                              receiver_user: receiver_user,
                              member_type: member_type)
    end

    context 'with valid params' do
      it { expect(subject.class).to eq(FamilyConnection) }
      it { expect { subject }.to change(FamilyConnection, :count).by(1) }
      it { expect { subject }.to_not raise_error }
      it { expect(subject.requestor_user_id).to eq(requestor_user.id) }
      it { expect(subject.receiver_user_id).to eq(receiver_user.id) }
    end

    describe 'raise error' do
      %i[requestor_user receiver_user member_type].each do |ff|
        context "when #{ff} is missing" do
          let(ff.to_sym) { nil }
          it { expect { subject }.to raise_error ArgumentError }
        end
      end
      context 'when Requestor and Reiceiver the same' do
        subject do
          described_class.perform(requestor_user: requestor_user,
                                  receiver_user: requestor_user,
                                  member_type: member_type)
        end

        it { expect { subject }.to raise_error ArgumentError }
      end
    end
  end
end
