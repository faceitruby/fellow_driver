# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParseExceptionService do
  describe '#call' do
    subject { described_class.perform(exception: exception) }
    context 'with' do
      let(:message) { Faker::Lorem.sentence }

      context 'ActiveRecord::RecordNotUnique' do
        let(:exception) { ActiveRecord::RecordNotUnique.new(message) }

        it { is_expected.to include(message: message, status: :unprocessable_entity) }
      end

      context 'ActiveRecord::RecordInvalid' do
        let(:message) { 'Validation failed: Email or phone Fill in the email or phone field' }
        let(:user) { build(:user, :create, email: nil, phone: nil) }
        let(:exception) { ActiveRecord::RecordInvalid.new(user) }

        before { user.valid? }

        it { is_expected.to include(message: message, status: :unprocessable_entity) }
      end

      context 'ActiveRecord::RecordNotFound' do
        let(:exception) { ActiveRecord::RecordNotFound.new(message) }

        it { is_expected.to include(message: message, status: :unprocessable_entity) }
      end

      context 'ArgumentError' do
        let(:exception) { ArgumentError.new(message) }

        it { is_expected.to include(message: message, status: :unprocessable_entity) }
      end

      context 'Koala::Facebook::AuthenticationError' do
        let(:exception) { Koala::Facebook::AuthenticationError.new(nil, message) }

        it { is_expected.to include(message: message, status: :unauthorized) }
      end

      context 'Warden::NotAuthenticated' do
        let(:exception) { Warden::NotAuthenticated.new(message) }

        it { is_expected.to include(message: message, status: :unauthorized) }
      end

      context 'JWT::DecodeError' do
        let(:message) { 'Token is not valid' }
        let(:exception) { JWT::DecodeError.new(message) }

        it { is_expected.to include(message: message, status: :unprocessable_entity) }
      end
    end
  end
end
