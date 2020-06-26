# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::Facebook::FetchFriendsService do
  shared_examples 'near is true' do
    it do
      expect(service_instance).to receive(:near_friends).once
      subject
    end
    it do
      expect(service_instance).to receive(:in_radius?).once
      subject
    end
  end

  shared_examples 'near is false' do
    it do
      expect(service_instance).to receive(:friends_uid).once
      subject
    end
    it do
      expect(service_instance).to receive(:near_friends).exactly(0).times
      subject
    end
    it do
      expect(service_instance).to receive(:in_radius?).exactly(0).times
      subject
    end
  end

  let(:access_token) { '123456789' }
  let(:current_user) { create(:user, :facebook) }
  let(:friend) { create(:user, :facebook) }
  let(:graph) { double(get_object: friends) }
  let(:service_instance) { described_class.new(params) }
  let(:params) do
    {
      current_user: current_user,
      access_token: access_token,
      near: near
    }
  end

  subject { service_instance.call }

  describe '#call' do
    context 'when user search friends' do
      let(:friends) do
        {
          friends: {
            data: [{ name: Faker::Lorem.word, uid: friend.uid }]
          }
        }.deep_stringify_keys
      end

      context 'and near_only option is true' do
        let(:near) { true }

        before do
          allow_any_instance_of(described_class).to receive(:graph).and_return(graph)
          allow(Geocoder).to receive_message_chain(:search, :[], :coordinates)
          allow(Geocoder::Calculations).to receive_message_chain(:distance_between, :<).and_return(within_radius)
        end

        context 'and existing friend is near' do
          let(:within_radius) { true }

          it { is_expected.to be_instance_of(Array) && be_present }
          it { expect(subject.first).to be_instance_of User }
          include_examples 'near is true'
        end

        context 'and existing friend is far' do
          let(:within_radius) { false }

          it { is_expected.to be_instance_of(Array) && be_blank }
          include_examples 'near is true'
        end

        context 'when friend doesn\'t have address' do
          let(:friend) { create(:user, :create, :facebook) }
          let(:within_radius) { false }

          it { is_expected.to be_instance_of(Array) && be_blank }
          include_examples 'near is true'
        end

        context 'when current_user doesn\'t have address' do
          let(:current_user) { create(:user, :create, :facebook) }
          let(:within_radius) { false }

          it { is_expected.to be_instance_of(Array) && be_blank }
          include_examples 'near is true'
        end
      end

      context 'and near_only option is false' do
        context 'and FB friends exists in DB' do
          let(:near) { false }

          before { allow_any_instance_of(described_class).to receive(:graph).and_return(graph) }

          it { is_expected.to be_instance_of(Array) && be_present }
          it { expect(subject.first).to be_instance_of User }
          include_examples 'near is false'
        end

        context 'and FB friends doesn\'t exist in DB' do
          let(:near) { false }
          let(:friends) do
            {
              friends: {
                data: [{ name: Faker::Lorem.word, uid: Faker::Number.number }]
              }
            }.deep_stringify_keys
          end

          before { allow_any_instance_of(described_class).to receive(:graph).and_return(graph) }

          it { is_expected.to be_instance_of(Array) && be_blank }
          include_examples 'near is false'
        end
      end
    end
  end
end
