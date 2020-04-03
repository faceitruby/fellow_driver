# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'field' do
    %i[
      id email phone encrypted_password reset_password_token reset_password_sent_at
      remember_created_at created_at updated_at jti provider uid first_name last_name address
      invitation_token invitation_created_at invitation_sent_at invitation_accepted_at
      invitation_limit invited_by_type invited_by_id invitations_count family_id member_type
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
      subject { user }

      context 'with email is set' do
        let(:user) { build(:user, :create, phone: nil) }

        it { is_expected.to be_valid(:create) }
      end

      context 'with phone is set' do
        let(:user) { build(:user, :create, email: nil) }

        it { is_expected.to be_valid(:create) }
      end

      context 'with both email and phone are missing' do
        let(:user) { build(:user, :create, email: nil, phone: nil) }

        it { is_expected.to_not be_valid(:create) }
      end

      context 'with missing password' do
        context 'and provider' do
          let(:user) { build(:user, :create, phone: nil, password: nil) }

          it { is_expected.to_not be_valid(:create) }
        end

        context 'but with provider' do
          let(:user) { build(:user, :create, phone: nil, password: nil, provider: 'facebook') }

          it { is_expected.to be_valid(:create) }
        end
      end
    end

    context 'when updating' do
      subject { user }

      context 'with all params are present' do
        let(:user) { build(:user) }

        it { is_expected.to be_valid(:update) }
      end

      %i[first_name last_name email phone address avatar].each do |field|
        context "with #{field} is missing" do
          let(:user) { build(:user, field => nil) }

          it { is_expected.to_not be_valid(:update) }
        end
      end

      context 'and email has been taken' do
        let!(:user) { create(:user, phone: nil) }
        subject { build(:user, email: user.email) }

        it { is_expected.to_not be_valid(:update) }
      end

      context 'and phone number has been taken' do
        let!(:user) { create(:user, email: nil) }
        subject { build(:user, phone: user.phone) }

        it { is_expected.to_not be_valid(:update) }
      end

      context 'with missing password' do
        let(:user) { build(:user, password: nil) }

        it { is_expected.to be_valid(:update) }
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
