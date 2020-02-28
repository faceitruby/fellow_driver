require 'rails_helper'

RSpec.describe Car, type: :model do
  context 'fields' do
    %i[
      id user_id manufacturer model year color
      license_plat_number created_at updated_at
    ].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  context 'Associations' do
    %i[user].each do |association|
      it 'belongs to user by user_id field' do
        is_expected.to belong_to(association)
      end
    end
  end

  context 'Atached' do
    let(:car) { build(:car) }
    it do
      expect(car.picture).to be_attached
    end
  end

  context 'Validation' do
    let(:car) { create(:car) }
    it do
      expect(car).to be_valid
    end

    %i[
      manufacturer model year color license_plat_number
    ].each do |field|
      it do
        car[field] = nil
        expect(car).to_not be_valid
      end
    end

    it do
      car.picture = nil
      expect(car).to_not be_valid
    end
  end
end
