# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::FetchPlaceIdService do
  describe '#call' do
    let(:params) { { address: Faker::Address.full_address } }
    let(:result) { [OpenStruct.new(place_id: 'place_id')] }

    subject { described_class.perform(params) }

    context 'when address provided' do
      before { expect(Geocoder).to receive(:search).once.and_return(result) }

      it { expect { subject }.to_not raise_error }
    end

    context 'when address is missing' do
      let(:message) { 'Address is missing' }
      let(:params) { {} }

      before { expect(Geocoder).to_not receive(:search) }

      it { expect { subject }.to raise_error ArgumentError, message }
    end
  end
end
