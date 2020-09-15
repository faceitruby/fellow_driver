# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::FetchService do
  describe 'call' do
    let(:user) { create(:user, :create) }

    subject { described_class.perform(user: user) }

    context 'when user has ride_requests' do
      let!(:ride) { create(:ride, requestor: user) }

      it { is_expected.to be_instance_of Array }
      it { expect(subject.first).to eq ride }
    end

    context 'when user does not have ride_requests' do
      it { is_expected.to eq [] }
    end
  end
end
