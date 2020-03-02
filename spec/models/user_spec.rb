# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'fields' do
    %i[id email phone encrypted_password reset_password_token reset_password_sent_at
       remember_created_at created_at updated_at jti provider uid first_name
       last_name address].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'indexes' do
    %i[email reset_password_token jti].each do |field|
      it { is_expected.to have_db_index(field).unique(true) }
    end
  end

  describe 'validations' do
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

    context 'on POST#create' do
      let(:user_without_email_phone) { build(:user, :create_params_only, email: nil, phone: nil) }

      context 'when email is set' do
        it 'valid' do
          expect(build(:user, :create_params_only, phone: nil)).to be_valid(:create)
        end
      end
      context 'when phone is set' do
        it 'valid' do
          expect(build(:user, :create_params_only, email: nil)).to be_valid(:create)
        end
      end
      context 'when both email and phone aren\'t set' do
        it 'not valid' do
          expect(user_without_email_phone).to_not be_valid(:create)
        end
      end
    end
    context 'on POST#update' do
      context 'when all params present' do
        it 'valid' do
          expect(build(:user)).to be_valid(:update)
        end
      end
      %i[first_name last_name email phone address avatar].each do |field|
        context "when #{field} is missing" do
          it 'not valid' do
            expect(build(:user, field => nil)).not_to be_valid(:update)
          end
        end
      end
    end
  end
end
