# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavouriteLocation, type: :model do
  describe 'columns' do
    %i[id user_id name address created_at updated_at].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'assotiation' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validation' do
    subject { build(:favourite_location) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id)
                                             .with_message('is already in your Favourite Locations') }
    it { should validate_uniqueness_of(:address).scoped_to(:user_id)
                                                .with_message('is already in your Favourite Locations') }
  end
end

