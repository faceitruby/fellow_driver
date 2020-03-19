# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'trusted_driver_messages create' do

  it { expect(subject.class).to eq(String) }
  it { expect(subject).to eq(result) }
end

RSpec.describe TrustedDrivers::Messages::CreateService do
  let(:current_user) { create(:user)}
  let(:user_receiver) { create(:user)}
  subject do
     TrustedDrivers::Messages::CreateService.perform(current_user: current_user,user_receiver: user_receiver)
  end

  context 'when user' do
    context 'exist before' do
      let(:result) do
        "#{current_user.name} is inviting you to connect on KydRides.\
        Please click the link to accept the invitation:\
        #{ENV['HOST_ADDRESS']}/api/trusted_driver_requests"
      end

      it_behaves_like 'trusted_driver_messages create'
    end

    context 'now created' do
      before do
        allow_any_instance_of(TrustedDrivers::Messages::CreateService).to receive(:token).and_return(token)
      end

      let(:token) { 'token' }
      let(:result) do
        "#{current_user.name} is inviting you to connect on KydRides.\
        Please click the link to accept the invitation:\
        #{ENV['HOST_ADDRESS']}/api/users/invitation/accept?invitation_token=#{token}"
      end

      it_behaves_like 'trusted_driver_messages create'
    end
  end
end
