# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::RideCheckService do
  describe '#call' do
    subject { described_class.new(user: user).call }

    context 'when missing trust drivers' do
      let(:errors) { ['Connect with your friends to request rides'] }
      let(:user) { build(:user, :payment) }

      it { is_expected.to be false }
      it 'adds errors to user' do
        subject
        expect(user.errors.values).to include errors
      end
    end

    context 'when missing payments' do
      let(:errors) { ['Please setup a payment method to request rides'] }
      let(:user) { build(:user, :trusted_driver) }

      it { is_expected.to be false }
      it 'adds errors to user' do
        subject
        expect(user.errors.values).to include errors
      end
    end

    context 'when missing payment and trust drivers' do
      let(:errors) do
        [
          ['Connect with your friends to request rides'],
          ['Please setup a payment method to request rides']
        ]
      end
      let(:user) { build(:user) }

      it { is_expected.to be false }
      it 'adds errors to user' do
        subject
        expect(user.errors.values).to include errors[0]
        expect(user.errors.values).to include errors[1]
      end
    end

    context 'when provided payments and trust drivers' do
      let(:user) { build(:user, :payment, :trusted_driver) }

      it { is_expected.to be true }
    end
  end
end
