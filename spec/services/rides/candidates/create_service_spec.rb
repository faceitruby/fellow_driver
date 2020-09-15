# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::Candidates::CreateService do
  shared_examples 'success creating' do
    let(:second_connection) { false }
    let(:expected_status) { 'accepted' }

    it { expect(subject.second_connection).to be second_connection }
    it do
      subject.reload
      expect(subject.status).to eq expected_status
    end
    it { expect { subject }.to change(DriverCandidate, :count).by(1) }
    it { is_expected.to be_instance_of DriverCandidate }
  end

  describe '#call' do
    let(:user) { create(:user) }
    let(:first_connection_driver) { create(:trusted_driver, trust_driver: user).trusted_driver }
    let(:second_connection_driver) { create(:trusted_driver, trust_driver: first_connection_driver).trusted_driver }
    let(:ride) { create(:ride, requestor: user) }
    let(:status) { :accepted }
    let(:params) do
      {
        driver_id: first_connection_driver.id,
        id: ride.id,
        status: status
      }
    end

    subject { described_class.perform(params) }

    context 'with missing' do
      { driver_id: 'Driver is missing',
        id: 'Ride is missing' }.each do |field, description|
        context field.to_s do
          let(:params) { super().except(field) }

          it { expect { subject }.to raise_error ArgumentError, description }
        end
      end
    end

    context 'when driver tries accept a ride second time' do
      let!(:existing_candidate) { create :driver_candidate, ride: ride, driver: first_connection_driver }
      let(:message) { 'Validation failed: Driver has already accepted this ride' }

      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid, message }
      it { expect { subject_ignore_exceptions }.not_to change(DriverCandidate, :count) }
    end

    context 'when driver is a trusted_driver for user' do
      context 'when accepting' do
        include_examples 'success creating'
      end

      context 'when dismissing' do
        let(:status) { :dismissed_by_candidate }

        include_examples 'success creating' do
          let(:expected_status) { 'dismissed_by_candidate' }
        end
      end
    end

    context 'when driver is a trusted_driver for user\'s trusted driver' do
      let(:params) { super().merge(driver_id: second_connection_driver.id) }

      context 'when accepting' do
        include_examples 'success creating' do
          let(:second_connection) { true }
          let(:expected_status) { 'created' }
        end
      end

      context 'when dismissing' do
        let(:status) { :dismissed_by_candidate }

        include_examples 'success creating' do
          let(:second_connection) { true }
          let(:expected_status) { 'dismissed_by_candidate' }
        end
      end
    end

    context 'when driver is not a trusted driver for a requestor' do
      let(:trusted_driver) { create :user, :create }
      let(:params) { super().merge(driver_id: user.id) }
      let(:message) { 'Not a trusted driver' }

      it { expect { subject }.to raise_error ArgumentError, message }
    end
  end
end
