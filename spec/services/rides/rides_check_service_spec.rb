# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::RideCheckService do
  describe '#call' do
    let(:result) { OpenStruct.new(success?: false, errors: errors, data: nil) }
    subject { described_class.new(user: user).call }

    # TODO: CHANGE CARS WITH TRUST DRIVER
    context 'when missing trust drivers' do
      let(:errors) { { cars: ["Connect with your friends to request rides"] } }
      let(:user) { build(:user, :payment) }

      it { is_expected.to eq result }
    end

    context 'when missing payments' do
      let(:errors) { { payments: ['Please setup a payment method to request rides'] } }
      let(:user) { build(:user, :car) }

      it { is_expected.to eq result }
    end

    context 'when missing payment and trust drivers' do
      let(:errors)  do
        {
          cars: ["Connect with your friends to request rides"],
          payments: ['Please setup a payment method to request rides']
        }
      end
      let(:user) { build(:user) }

      it { is_expected.to eq result }
    end

    context 'when provided payments and trust drivers' do
      let(:result) { OpenStruct.new(success?: true, errors: nil, data: { message: 'ok' }) }
      let(:user) { build(:user, :payment, :car) }

      it { is_expected.to eq result }
    end
  end
end