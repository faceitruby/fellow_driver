# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member, type: :model do
  let!(:user) { create(:valid_user) }
  let!(:member) { create(:valid_member) }

  context 'assotiation' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validation' do
    %i[first_name
       last_name
       phone
       birth_day
       relationship].each do |field|
      it { is_expected.to validate_presence_of(:"#{field}") }
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'validation' do
    context 'email' do
      %w[user@example.com user_1@exame.com user.1@example.com].each do |email|
        it { is_expected.to allow_value(email).for(:email) }
      end
      %w[@example.com example.com user@example@com].each do |email|
        it { is_expected.to_not allow_value(email).for(:email) }
      end
    end
    context 'phone' do
      %w[123-456-7890].each do |phone|
        it { is_expected.to allow_value(phone).for(:phone) }
      end
      %w[123--456-7890 qwe-asd-zxcv 1234567890 123-456-789O].each do |phone|
        it { is_expected.to_not allow_value(phone).for(:phone) }
      end
    end
    context 'birth_day' do
      %w[26.05.1984 11/12/2000 15-01-1916 19*11*1475].each do |birth_day|
        it { is_expected.to allow_value(birth_day).for(:birth_day) }
      end
      %w[6-5-1984 11.12].each do |birth_day|
        it { is_expected.to_not allow_value(birth_day).for(:birth_day) }
      end
    end
  end

  context 'creating' do
    it 'with valid params is VALID' do
      expect(member).to be_valid
    end
    it 'will increase members count in DB' do
      expect { member.destroy }.to change { Member.count }.by(-1)
    end
  end
end
