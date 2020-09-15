# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::DistanceService do
  let(:params) do
    {
      start_place_id: Faker::Address.full_address,
      end_place_id: Faker::Address.full_address,
      time: (Time.current + 1.day).to_s
    }
  end
  let(:status) { 'ZERO_RESULTS' }
  let(:result) do
    {
      some_data: 'data',
      rows: [elements: [status: status,
                        duration_in_traffic: {
                          text: 'some duration',
                          value: 123
                        },
                        distance: {
                          text: 'some distance',
                          value: 456
                        }]]
    }
  end

  subject { described_class.perform(params) }

  describe '#call' do
    context 'when status is' do
      let(:expected) { [status] }

      before do
        expect_any_instance_of(GoogleMapsService::Client).to receive(:distance_matrix).and_return result
      end

      context 'ZERO_RESULTS' do
        it { is_expected.to eq expected }
      end

      context 'NOT_FOUND' do
        let(:status) { 'NOT_FOUND' }

        it { is_expected.to eq expected }
      end

      context 'OK' do
        let(:status) { 'OK' }
        let(:expected) do
          {
            duration_in_traffic: {
              text: 'some duration',
              value: 123
            },
            distance: {
              text: 'some distance',
              'value': 456
            }
          }
        end

        it { is_expected.to eq expected }
      end

      context 'MAX_ROUTE_LENGTH_EXCEEDED' do
        let(:status) { 'MAX_ROUTE_LENGTH_EXCEEDED' }

        it { is_expected.to eq result }
      end
    end
    context 'with missing' do
      before do
        expect_any_instance_of(GoogleMapsService::Client).to_not receive(:distance_matrix)
      end

      { start_place_id: 'ride start place id is missing',
        end_place_id: 'ride end place id is missing',
        time: 'ride starting time is missing' }.each do |param, description|
        context param.to_s do
          let!(:params) { super().except param }

          it { expect { subject }.to raise_error ArgumentError, description }
        end
      end
    end
  end
end
