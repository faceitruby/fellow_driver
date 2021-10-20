# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavouriteLocations::UpdateService do
  describe '#call' do
    let(:current_user) { create(:user) }
    let!(:favourite_location) { create(:favourite_location, user: current_user) }
    let(:new_favourite_locations_attributes) { attributes_for(:favourite_location) }
    let(:params) do
      new_favourite_locations_attributes.merge(favourite_location: favourite_location,
                                               current_user: current_user)
    end

    subject { described_class.perform(params) }

    context 'with valid params' do
      it { expect { subject }.to_not change(FavouriteLocation, :count) }
      it { expect { subject }.to_not raise_error }

      it do
        expect { subject }.to change(favourite_location, :name)
          .from(favourite_location.name)
          .to(new_favourite_locations_attributes[:name])
      end
      it do
        expect { subject }.to change(favourite_location, :address)
          .from(favourite_location.address)
          .to(new_favourite_locations_attributes[:address])
      end
    end

    context 'without favourite_location' do
      let(:params) { new_favourite_locations_attributes.merge(favourite_location: nil, current_user: current_user) }

      it { expect { subject }.to raise_error ArgumentError, 'Favourite Location not found' }
    end

    context 'if favourite_location doesnt belong to user' do
      let(:params) { new_favourite_locations_attributes.merge(favourite_location: 777, current_user: current_user) }

      it { expect { subject }.to raise_error ArgumentError, 'You are not allowed to update this data' }
    end
  end
end
