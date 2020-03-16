# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AddressAutocompleteController, type: :controller do
  describe 'routes' do
    it { is_expected.to route(:post, '/api/users/address_autocomplete/complete').to(action: :complete, format: :json) }
  end

  describe 'POST#complete' do
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
    let(:params) do
      {
        search: {
          input: input
        }
      }
    end
    let(:input) { 'some search' }
    let(:google_response) { OpenStruct.new(body: body.to_json) }
    let(:send_request) { post :complete, params: params, as: :json }
    subject { response }

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      allow_any_instance_of(GooglePlacesAutocomplete::Client).to receive(:autocomplete).with(an_instance_of(Hash))
                                                                                       .and_return(google_response)
    end

    context 'when token is missing' do
      before { send_request }

      it { is_expected.to have_http_status(400) }
      it_behaves_like 'failure action'
    end

    context 'when input' do
      before do
        allow(controller).to receive(:check_authorize).and_return(nil)
        send_request
      end

      context 'is present' do
        it { is_expected.to have_http_status(200) }
        it_behaves_like 'success action'
      end

      context 'is missing' do
        let(:input) {}
        let(:google_response) { OpenStruct.new(body: body_when_missing_input.to_json) }

        it { is_expected.to have_http_status(422) }
        it_behaves_like 'failure action'
      end
    end
  end
end
