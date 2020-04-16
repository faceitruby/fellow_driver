# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'trusted_driver_messages create' do
  it { expect(subject.class).to eq(String) }
  it { expect(subject).to eq(result) }
end

RSpec.describe TrustedDrivers::Messages::CreateService do
  let(:current_user) { create(:user) }
  let(:user_receiver) { create(:user) }

  let(:result) do
    <<~MSG
      #{current_user.name} is inviting you to connect on KydRides.
      Please click the link to accept the invitation:
      #{url}
    MSG
  end

  let(:params) do
    {
      current_user: current_user,
      user_receiver: user_receiver
    }
  end

  subject { described_class.perform(params) }

  describe '#call' do
    context 'when user' do
      context 'exist before' do
        let(:url) { "#{ENV['HOST_ADDRESS']}/api/trusted_driver_requests" }

        it_behaves_like 'trusted_driver_messages create'
      end

      context 'now created' do
        let(:token) { 'token' }
        let(:url) { "#{ENV['HOST_ADDRESS']}/api/users/invitation/accept?invitation_token=#{token}" }

        before do
          allow_any_instance_of(described_class).to receive(:token).and_return(token)
        end

        it_behaves_like 'trusted_driver_messages create'
      end
    end
  end
end
