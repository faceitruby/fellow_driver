# frozen_string_literal: true

require 'rails_helper'
require 'support/shared/results_shared'

RSpec.describe Users::AddressAutocompleteService do
  let(:params) { { input: 'search' } }
  subject { described_class.new(params).call }
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

  describe '#call' do
    before(:each) do
      allow_any_instance_of(GooglePlacesAutocomplete::Client).to receive(:autocomplete).with(an_instance_of(Hash))
                                                                                       .and_return(response)
    end

    context 'when input present' do
      it { is_expected.to be_instance_of OpenStruct }
      it_behaves_like 'when fields present'
    end
    context 'when input missing' do
      let(:params) { { language: 'ru' } }
      let(:response) { OpenStruct.new(body: body_when_missing_input.to_json) }

      it { is_expected.to be_instance_of OpenStruct }
      it_behaves_like 'when fields missed'
    end
  end
end
