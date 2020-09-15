# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::NotificateDriversService do
  describe '#call' do
    let(:user) { create :user }
    let(:second_connection) { false }
    let(:params) do
      {
        id: user.id,
        second_connection: second_connection
      }
    end

    subject { described_class.perform(params) }

    context 'when drivers from first_connection' do
      let(:trusted_driver) { create :trusted_driver, trust_driver: user }

      it do
        expect(Resque).to receive(:enqueue).with(NotificateDriversJob, [trusted_driver])
        subject
      end
    end

    context 'when drivers from second_connection' do
      let(:existing_trusted_driver) { create :trusted_driver, trust_driver: user }
      let(:trusted_driver) { create :trusted_driver, trust_driver: existing_trusted_driver.trusted_driver }
      let(:second_connection) { true }

      it do
        expect(Resque).to receive(:enqueue).with(NotificateDriversJob, [trusted_driver])
        subject
      end
    end
  end
end
