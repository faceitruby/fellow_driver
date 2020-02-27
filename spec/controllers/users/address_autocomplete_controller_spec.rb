# frozen_string_literal: true

require 'rails_helper'
require 'support/shared/results_shared'

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
    let(:subject) { post :complete, params: params, as: :json }
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      allow_any_instance_of(GooglePlacesAutocomplete::Client).to receive(:autocomplete).with(an_instance_of(Hash))
                                                                                       .and_return(google_response)
    end

    context 'when token is missing' do
      it 'gets 400 code' do
        subject
        expect(response).to have_http_status(400)
      end

      it_behaves_like 'render error response'
    end
    context 'when input is present' do
      before(:each) { allow(controller).to receive(:check_authorize).and_return(nil) }

      it 'gets 200 code' do
        subject
        expect(response).to have_http_status(200)
      end

      it_behaves_like 'render success response'
    end
    context 'when input is missing' do
      let(:input) {}
      let(:google_response) { OpenStruct.new(body: body_when_missing_input.to_json) }
      before(:each) { allow(controller).to receive(:check_authorize).and_return(nil) }

      it 'gets 422 code' do
        subject
        expect(response).to have_http_status(422)
      end

      it_behaves_like 'render error response'
    end
  end
end
