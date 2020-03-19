# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'field' do
    %i[
      id email phone encrypted_password reset_password_token reset_password_sent_at
      remember_created_at created_at updated_at jti provider uid first_name last_name address
    ].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'indexes' do
    %i[email reset_password_token jti].each do |field|
      it { is_expected.to have_db_index(field).unique(true) }
    end
  end

  describe 'validation' do
    %w[user@example.com user_1@example.com user.1@example.com].each do |email|
      it { is_expected.to allow_value(email).for(:email) }
    end
    %w[@example.com example.com user@example@com].each do |email|
      it { is_expected.to_not allow_value(email).for(:email) }
    end

    %w[123-456-7890].each do |phone|
      it { is_expected.to allow_value(phone).for(:phone) }
    end
    %w[123--456-7890 qwe-asd-zxcv 1234567890 123-456-789O].each do |phone|
      it { is_expected.to_not allow_value(phone).for(:phone) }
    end

    context 'when creating' do
      let(:user_without_email_phone) { build(:user, :create, email: nil, phone: nil) }

      context 'and email is set' do
        it 'and is valid' do
          expect(build(:user, :create, phone: nil)).to be_valid(:create)
        end
      end

      context 'and phone is set' do
        it 'and is valid' do
          expect(build(:user, :create, email: nil)).to be_valid(:create)
        end
      end

      context 'and both email and phone are missing' do
        it 'is not valid' do
          expect(user_without_email_phone).to_not be_valid(:create)
        end
      end
    end

    context 'when updating' do
      context 'and all params are present' do
        it 'and valid' do
          expect(build(:user)).to be_valid(:update)
        end
      end

      %i[first_name last_name email phone address avatar].each do |field|
        context "and #{field} is missing" do
          it 'is not valid' do
            expect(build(:user, field => nil)).not_to be_valid(:update)
          end
        end
      end
    end
  end

  describe 'associations' do
    %i[cars payments].each do |association|
      it { is_expected.to have_many(association) }
    end

    it { is_expected.to have_one(:family) }
  end
end
