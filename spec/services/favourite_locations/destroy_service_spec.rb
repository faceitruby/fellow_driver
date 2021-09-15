# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavouriteLocations::DestroyService do
  describe '#call' do
    let(:current_user) { create(:user) }
    let!(:favourite_location) { create(:favourite_location, user: current_user) }
    let(:params) { { favourite_location: favourite_location, current_user: current_user } }

    subject { described_class.perform(params) }

    context 'with valid params' do
      it { expect { subject }.to change(FavouriteLocation, :count).by(-1) }
      it { expect { subject }.to_not raise_error }
    end

    context 'without favourite_location' do
      let(:params) { { favourite_location: nil, current_user: current_user } }

      it { expect{ subject }.to raise_error ArgumentError, 'Favourite Location not found' }
    end

    context 'if favourite_location doesnt belong to user' do
      let(:params) { { favourite_location: 777, current_user: current_user } }

      it { expect{ subject }.to raise_error ArgumentError, 'You are not allowed to destroy this data' }
    end
  end
end
