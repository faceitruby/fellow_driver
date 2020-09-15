# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::Candidates::ChangeAcceptedService do
  describe '#call' do
    let(:candidate) { create :driver_candidate }
    let(:params) do
      {
        id: candidate.id,
        status: status
      }
    end

    subject { described_class.perform(params) }

    context 'when accepted is true' do
      let(:status) { :accepted }

      context 'with candidate provided' do
        it { expect { subject }.not_to raise_error }
        it do
          subject
          candidate.reload
          expect(candidate.status).to eq 'accepted'
        end
        it do
          subject
          candidate.reload
          expect(candidate.ride.status).to eq 'driver_found'
        end
      end

      context 'with candidate missing' do
        let(:params) { super().except(:id) }
        let(:message) { 'Couldn\'t find DriverCandidate without an ID' }

        it { expect { subject }.to raise_error ActiveRecord::RecordNotFound, message }
      end
    end

    context 'when accepted is false' do
      let(:status) { :dismissed_by_requestor }

      context 'with candidate provided' do
        it { expect { subject }.not_to raise_error }
        it do
          subject
          candidate.reload
          expect(candidate.status).to eq 'dismissed_by_requestor'
        end
        it do
          subject
          candidate.reload
          expect(candidate.ride.status).to eq 'created'
        end
      end

      context 'with candidate missing' do
        let(:params) { super().except(:id) }
        let(:message) { 'Couldn\'t find DriverCandidate without an ID' }

        it { expect { subject }.to raise_error ActiveRecord::RecordNotFound, message }
      end
    end

    context 'when accept is missing' do
      let(:status) { nil }

      context 'with candidate provided' do
        let(:message) { 'Status must be set' }

        it { expect { subject }.to raise_error ArgumentError, message }
      end

      context 'with candidate missing' do
        let(:params) { super().except(:id) }
        let(:message) { 'Status must be set' }

        it { expect { subject }.to raise_error ArgumentError, message }
      end
    end
  end
end
