# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AddressAutocompleteService do
  let(:params) { { input: 'search' } }
  let(:body) do
    {
      predictions: [
        {
          description: 'Some Place',
          id: 'Some id',
          place_id: 'place_id',
          reference: 'place_id',
          types: %w[route geocode]
        },
        {
          description: 'Another some place',
          id: 'Another some id',
          place_id: 'Another place_id',
          reference: 'Another place_id',
          types: %w[route geocode]
        }
      ],
      status: 'OK'
    }
  end
  let(:body_when_missing_input) do
    {
      predictions: [],
      status: 'INVALID_REQUEST'
    }
  end
  let(:response) { OpenStruct.new(body: body.to_json) }
  subject { described_class.new(params).call }

  describe '#call' do
    before do
      allow_any_instance_of(GooglePlacesAutocomplete::Client).to receive(:autocomplete).with(an_instance_of(Hash)).and_return(response)
    end

    context 'when input' do
      context 'is present' do
        it { is_expected.to be_instance_of OpenStruct }
        it_behaves_like 'provided fields'
      end

      context 'is missed' do
        let(:params) { { language: 'ru' } }
        let(:response) { OpenStruct.new(body: body_when_missing_input.to_json) }

        it { is_expected.to be_instance_of OpenStruct }
        it_behaves_like 'missing fields'
      end
    end
  end
end
