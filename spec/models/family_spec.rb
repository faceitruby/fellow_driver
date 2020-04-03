# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Family, type: :model do
  let(:user) { create(:user) }
  let(:family) { create(:family) }

  context 'validation' do
    %i[user_id].each do |field|
      it { is_expected.to validate_presence_of(:"#{field}") }
    end
  end

  context 'assotiation' do
    it { is_expected.to have_many(:users) }
  end

  context 'creating' do
    before { user }
    it 'be valid with valid attributes' do
      expect(family).to be_valid
    end

    %i[user_id].each do |invalid_attributes|
      it "be INVALID with invalid '#{invalid_attributes}'" do
        expect(build(:family, "#{invalid_attributes}": nil)).to_not be_valid
      end
    end

    it 'should increase Family count in DB by 1' do
      expect{family}.to change{Family.count}.by(1)
    end

  end
  context 'deleting' do
    before do
      user
      family
    end

    it 'should decrease Family count in DB by -1' do
      expect{family.destroy}.to change{Family.count}.by(-1)
    end
  end
end
