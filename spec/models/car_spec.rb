# frozen_string_literal: true

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
      it { is_expected.to belong_to(association) }
    end
  end

  context 'Picture' do
    let(:car) { build(:car) }
    it { expect(car.picture).to be_attached }
  end

  context 'Validation' do
    let(:car) { create(:car) }

    %i[manufacturer model year color picture license_plat_number].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
  end
end
