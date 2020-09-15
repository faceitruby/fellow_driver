# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamilyMembers::FetchRelationService do
  describe '#call' do
    let(:params) { { passengers: passengers.pluck(:id) } }
    let(:expected_response) do
      [
        { relation: passengers[0].member_type, name: passengers[0].first_name },
        { relation: passengers[1].member_type, name: passengers[1].first_name }
      ]
    end

    before { allow(User).to receive(:find).with(params[:passengers]).and_return(passengers) }

    subject { described_class.perform(params) }

    context 'with correct params' do
      let(:family) { build_stubbed :family }
      let(:passengers) { build_stubbed_list :user, 2, :random_member, family_id: family.id }

      it { is_expected.to eq expected_response }
    end

    context 'when users in different families' do
      let(:passengers) { build_stubbed_list :user, 2, :random_member }
      let(:message) { 'Passengers are in different families' }

      it { expect { subject }.to raise_error ArgumentError, message }
    end

    context 'when passengers are missing' do
      let(:passengers) { {} }
      let(:params) { {} }
      let(:message) { 'Passengers are missing' }

      before { allow(User).to receive(:find).and_call_original }

      it { expect { subject }.to raise_error ArgumentError, message }
    end

    context 'when family owner is passenger' do
      let(:passengers) { build_stubbed_list :user, 1, member_type: 'owner' }
      let(:expected_response) do
        [
          { relation: 'me', name: passengers[0].first_name }
        ]
      end

      it { is_expected.to eq expected_response }
    end
  end
end
