# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::DistanceMatrixService do
  let(:expected_response) do
    {
      distance_text: '6.0 km',
      distance_in_meters: 5973,
      duration_text: '10 min',
      duration_in_seconds: 587
    }
  end
  let(:distance_matrix_client) do
    double(:distance_matrix_client,
           origins: [],
           destinations: [],
           data:
             [
               [
                 status: 'ok',
                 distance_text: '6.0 km',
                 distance_in_meters: 5973,
                 duration_text: '10 min',
                 duration_in_seconds: 587
               ]
             ])
  end

  before do
    allow(GoogleDistanceMatrix::Matrix).to receive(:new).and_return(distance_matrix_client)
  end

  describe '#call' do
    subject do
      described_class.perform({ origin: 'Inverdoorn Nature Reserve, Breede River DC, Южная Африка',
                                destination: 'проспект Соборный, 6, Запорожье, Запорожская обл, Украина' })
    end

    context "when status = 'ok'" do
      it { expect(subject).to eq(expected_response) }
    end

    context "when status = 'not_found'" do
      let(:distance_matrix_client) do
        double(:distance_matrix_client,
               origins: [],
               destinations: [],
               data: [[status: 'not_found']])
      end
    end

    context "when status = 'zero_results'" do
      let(:distance_matrix_client) do
        double(:distance_matrix_client,
               origins: [],
               destinations: [],
               data: [[status: 'zero_results']])
      end

      it { expect { subject }.to raise_error(ArgumentError, 'No route could be found between Origin or Destination') }
    end

    context "when status = 'max_route_length_exceeded'" do
      let(:distance_matrix_client) do
        double(:distance_matrix_client,
               origins: [],
               destinations: [],
               data: [[status: 'max_route_length_exceeded']])
      end

      it { expect { subject }.to raise_error(ArgumentError, 'Requested route is too long and cannot be processed') }
    end

    context 'without destination' do
      subject { described_class.perform({ origin: 'Inverdoorn Nature Reserve, Breede River DC, Южная Африка' }) }

      it { expect { subject }.to raise_error(ArgumentError, 'Destination must be provided') }
    end

    context 'without origin' do
      subject { described_class.perform({ destination: 'проспект Соборный, 6, Запорожье, Запорожская обл, Украина' }) }

      it { expect { subject }.to raise_error(ArgumentError, 'Origin must be provided') }
    end
  end
end
