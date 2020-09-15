# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'constants' do
    describe 'EXCEPTIONS' do
      let(:exceptions) do
        %w[ ActiveRecord::RecordNotUnique
            ActiveRecord::RecordInvalid
            ActiveRecord::RecordNotFound
            ActiveRecord::RecordNotDestroyed
            ArgumentError
            Warden::NotAuthenticated
            Koala::Facebook::AuthenticationError
            Koala::Facebook::ClientError
            Stripe::InvalidRequestError
            Stripe::APIConnectionError
            ActionController::InvalidAuthenticityToken
            Koala::KoalaError
            JWT::DecodeError
            Twilio::REST::TwilioError
            Users::AddressAutocompleteService::OverQuotaLimitError
            Users::AddressAutocompleteService::UnknownError
            StandardError]
      end

      it { expect(described_class::EXCEPTIONS).to eq exceptions }
    end
  end

  describe 'rescue_from' do
    described_class::EXCEPTIONS.each do |exception|
      it { is_expected.to rescue_from(exception).with(:exception_handler) }
    end
  end
end
