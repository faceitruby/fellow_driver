# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExceptionPresenter do
  describe '#page_context' do
    subject { described_class.new(exception).page_context }
    context 'with' do
      let(:message) { Faker::Lorem.sentence }

      context 'ActiveRecord::RecordInvalid' do
        let(:message) { 'Validation failed: Email or phone Fill in the email or phone field' }
        let(:user) { build(:user, :create, email: nil, phone: nil) }
        let(:exception) { ActiveRecord::RecordInvalid.new(user) }

        before { user.valid? }

        it { is_expected.to include(message: message, status: :unprocessable_entity) }
      end

      [ActiveRecord::RecordNotUnique, ActiveRecord::RecordNotFound, ArgumentError,
       Users::AddressAutocompleteService::OverQuotaLimitError,
       Users::AddressAutocompleteService::UnknownError].each do |exception_class|
        context exception_class.to_s do
          let(:exception) { exception_class.new(message) }

          it { is_expected.to include(message: message, status: :unprocessable_entity) }
        end
      end

      [Warden::NotAuthenticated, ActionController::InvalidAuthenticityToken].each do |exception_class|
        context exception_class.to_s do
          let(:exception) { exception_class.new(message) }

          it { is_expected.to include(message: message, status: :unauthorized) }
        end
      end

      context 'Koala::Facebook::AuthenticationError' do
        let(:exception) { Koala::Facebook::AuthenticationError.new(nil, message) }

        it { is_expected.to include(message: message, status: :unauthorized) }
      end

      context 'JWT::DecodeError' do
        let(:message) { 'Token is not valid' }
        let(:exception) { JWT::DecodeError.new(message) }

        it { is_expected.to include(message: message, status: :unprocessable_entity) }
      end

      context 'Koala::Facebook::ClientError' do
        let(:exception) { Koala::Facebook::ClientError.new(nil, message) }

        it { is_expected.to include(message: message, status: :bad_request) }
      end

      context 'Stripe::InvalidRequestError' do
        let(:exception) { Stripe::InvalidRequestError.new(message, nil) }

        it { is_expected.to include(message: message, status: :bad_request) }
      end

      [ActiveRecord::RecordNotDestroyed,
       Stripe::APIConnectionError, Koala::KoalaError, Twilio::REST::TwilioError,
       StandardError].each do |exception_class|
        context exception_class.to_s do
          let(:exception) { exception_class.new(message) }

          it { is_expected.to include(message: message, status: :bad_request) }
        end
      end
    end
  end
end
