# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AddressAutocompleteService do
  let(:body) do
    {
      predictions: predictions,
      status: status
    }.stringify_keys
  end
  let(:response) { double(body: body.to_json) }
  let(:predictions) { [] }
  let(:status) { 'OK' }

  subject { described_class.new(params).call }

  describe '#call' do
    before do
      allow_any_instance_of(GooglePlacesAutocomplete::Client).to receive(:autocomplete).with(an_instance_of(Hash))
                                                                                       .and_return(response)
    end

    context 'when response status is' do
      let(:params) { { input: 'search' }.stringify_keys }

      context 'OK' do
        let(:predictions) { [{ description: 'Some Place' }] }

        it { expect { subject }.to_not raise_error }
        it { is_expected.to be_present && be_instance_of(Array) }
      end

      context 'ZERO_RESULTS' do
        let(:status) { 'ZERO_RESULTS' }

        it { expect { subject }.to_not raise_error }
        it { is_expected.to eq [] }
      end

      context 'INVALID_REQUEST' do
        let(:status) { 'INVALID_REQUEST' }

        it { expect { subject }.to raise_error ArgumentError }
      end

      context 'REQUEST_DENIED' do
        let(:status) { 'REQUEST_DENIED' }

        it { expect { subject }.to raise_error ArgumentError }
      end

      context 'OVER_QUERY_LIMIT' do
        let(:status) { 'OVER_QUERY_LIMIT' }

        it { expect { subject }.to raise_error described_class::OverQuotaLimitError }
      end

      context 'UNKNOWN_ERROR' do
        let(:status) { 'UNKNOWN_ERROR' }

        it { expect { subject }.to raise_error described_class::UnknownError }
      end
    end
  end
end
