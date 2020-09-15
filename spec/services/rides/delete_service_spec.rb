# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::DeleteService do
  let!(:ride) { create(:ride) }

  let(:request_params) { { ride: ride } }

  subject { described_class.perform(request_params) }

  describe '#call' do
    context 'Ride presence' do
      it { expect { subject }.to_not raise_error }
      it { expect { subject }.to change(Ride, :count).by(-1) }
      it { expect(subject.destroyed?).to be true }
    end

    context 'Ride empty' do
      let(:request_params) { {} }

      it { expect { subject }.to raise_error ArgumentError, 'Ride request not found' }
    end
  end
end
