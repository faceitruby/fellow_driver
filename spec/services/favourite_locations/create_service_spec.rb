# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavouriteLocations::CreateService do
  describe '#call' do
    let(:current_user) { create(:user) }
    let(:favourite_locations_attributes) { attributes_for(:favourite_location) }
    let(:params) { favourite_locations_attributes.merge(current_user: current_user) }

    subject { described_class.perform(params) }

    context 'with valid params' do
      it { expect(subject.class).to eq(FavouriteLocation) }
      it { expect { subject }.to change(FavouriteLocation, :count).by(1) }
      it { expect { subject }.to_not raise_error }
      it 'Favourite Location created after perform, belongs to current user' do
        subject
        expect(subject.user).to eq(current_user)
      end
    end

    context 'with invalid params' do
      let(:params) { favourite_locations_attributes }

      it { expect{ subject }.to raise_error ArgumentError, 'Current user is missing' }
    end
  end
end

