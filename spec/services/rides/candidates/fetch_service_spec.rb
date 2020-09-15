# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::Candidates::FetchService do
  describe '#call' do
    let(:user) { create(:user) }
    let(:count) { rand 1..4 }
    let(:ride) { create(:ride, requestor: user) }
    let(:params) { { ride_id: ride.id } }

    subject { described_class.perform(params) }

    # context 'when driver candidates exist' do
    #   let!(:driver_candidates) { create_list(:driver_candidate, count, ride: ride) }
    #
    #   it { expect(subject.size).to eq count }
    #   it { is_expected.to be_kind_of ActiveRecord::Relation }
    # end

    context 'when driver candidates don\'t exist' do
      it { expect(subject.size).to eq 0 }
      it { is_expected.to be_kind_of ActiveRecord::Relation }
    end
  end
end
