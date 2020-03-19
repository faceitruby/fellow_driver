# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'facebook_friend_list' do

  it { expect(subject.class).to eq(OpenStruct) }
  it { expect(subject.errors).to eq(nil) }
  it { expect(subject.success?).to be true }
  it { expect(subject.data).to eq(response) }
end

RSpec.describe TrustedDrivers::FacebookFriendsListService do
  let(:current_user) { create(:user, :facebook) }
  let(:friend) { create(:user, :facebook) }


  context 'when user' do
    context 'search near friends' do
      let(:access_token) { 123456789 }
      let(:friends_count) { 1 }
      let(:response) do
        [
          friend
        ]
      end
      before do
        allow_any_instance_of(TrustedDrivers::FacebookFriendsListService).to receive(:friends_uid).and_return(response)
        allow_any_instance_of(TrustedDrivers::FacebookFriendsListService).to receive(:in_radius?).and_return(true)
      end

      context 'friend near' do
        let(:in_radius_response) { true }

        subject { TrustedDrivers::FacebookFriendsListService.perform(current_user: current_user,access_token: access_token, near: false) }

        it_behaves_like 'facebook_friend_list'
      end

      context 'friend far' do
        let(:in_radius_response) { false}
        subject { TrustedDrivers::FacebookFriendsListService.perform(current_user: current_user,access_token: access_token, near: true) }

        it_behaves_like 'facebook_friend_list'
      end
    end
  end
end
