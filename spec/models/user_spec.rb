# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'field' do
    %i[id email phone encrypted_password reset_password_token reset_password_sent_at
       remember_created_at created_at updated_at jti provider uid first_name
       last_name address
    ].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'index' do
    %i[email reset_password_token jti].each do |field|
      it { is_expected.to have_db_index(field).unique(true) }
    end
  end

  describe 'validation' do
    context 'email' do
      %w[user@example.com user_1@example.com user.1@example.com].each do |email|
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

    context 'user' do
      context 'on create' do
        let(:user_with_email) { build(:user_with_email_phone, phone: nil) }
        let(:user_with_phone) { build(:user_with_email_phone, email: nil) }
        let(:user_without_email_phone) { build(:user_with_email_phone, email: nil, phone: nil) }

        it 'with email is valid' do
          expect(user_with_email).to be_valid(:create)
        end
        it 'with phone is valid' do
          expect(user_with_phone).to be_valid(:create)
        end
        it 'without email and phone is not valid' do
          expect(user_without_email_phone).to_not be_valid(:create)
        end
      end
      context 'on update' do
        it 'is valid with valid params' do
          expect(build(:correct_user_update)).to be_valid(:update)
        end
        it 'is not valid with wrong params' do
          expect(build(:user_with_missing_fields_update)).not_to be_valid(:update)
        end
      end
    end
  end
end
