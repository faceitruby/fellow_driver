# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'facebook_friend_list' do
  it { expect(subject.class).to eq(OpenStruct) }
  it { expect(subject.errors).to eq(nil) }
  it { expect(subject.success?).to be true }
  it { expect(subject.data).to eq(response) }
end

RSpec.describe TrustedDrivers::Facebook::FetchFriendsService do
  let(:access_token) { '123456789' }
  let(:current_user) { create(:user, :facebook) }
  let(:friend) { create(:user, :facebook) }

  let(:params) do
    {
      current_user: current_user,
      access_token: access_token,
      near: near
    }
  end

  subject { described_class.perform(params) }

  describe '#call' do
    context 'when user search' do
      let(:service_response) { [friend] }

      before do
        allow_any_instance_of(described_class).to receive(:friends_uid)
          .and_return(service_response)
      end

      context 'friends near' do
        before do
          allow_any_instance_of(described_class).to receive(:in_radius?)
            .and_return(in_radius_response)
        end

        context 'and friend near' do
          let(:in_radius_response) { true }
          let(:near) { true }
          let(:response) { service_response }

          it_behaves_like 'facebook_friend_list'
        end

        context 'and friend far' do
          let(:in_radius_response) { false }
          let(:near) { true }
          let(:response) { [] }

          it_behaves_like 'facebook_friend_list'
        end
      end

      context 'all friends' do
        let(:in_radius_response) { false }
        let(:near) { false }
        let(:response) { service_response }

        it_behaves_like 'facebook_friend_list'
      end
    end
  end
end
