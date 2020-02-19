require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'field' do
    %i[id email phone encrypted_password reset_password_token reset_password_sent_at
       remember_created_at created_at updated_at jti provider uid
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
  end

  context 'Associations' do
    %i[cars payments].each do |association|
      it 'belongs to user by user_id field' do
        is_expected.to have_many(association)
      end
    end
  end
end
