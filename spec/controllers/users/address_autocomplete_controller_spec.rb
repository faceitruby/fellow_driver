# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AddressAutocompleteController, type: :controller do
  describe 'routes' do
    it { is_expected.to route(:post, '/api/users/address_autocomplete/complete').to(action: :complete, format: :json) }
  end

  describe 'callbacks' do
    it { is_expected.to use_before_action(:authenticate_user!) }
  end

  describe 'POST#complete' do
    let(:body) do
      {
        predictions: predictions,
        status: response_status
      }
    end
    let(:result) { double(body: body.to_json) }
    let(:predictions) { [] }
    let(:params) do
      {
        search: {
          input: input
        }
      }
    end
    let(:input) { 'some search' }
    let(:send_request) { post :complete, params: params, as: :json }
    let(:field_name) { 'predictions' }

    subject { response }

    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when token is missing' do
      it_behaves_like 'with missing token'
    end

    context 'when input' do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(nil)
        allow_any_instance_of(GooglePlacesAutocomplete::Client).to receive(:autocomplete).with(an_instance_of(Hash))
                                                                                         .and_return(result)
        send_request
      end

      context 'is present' do
        context 'and returned status is \'OK\'' do
          let(:predictions) { [{ description: 'Some Place' }] }
          let(:response_status) { 'OK' }

          it_behaves_like 'success response'
          it { expect(subject.parsed_body['predictions']).to be_instance_of(Array) && be_present }
        end

        context 'and returned status is \'ZERO_RESULTS\'' do
          let(:response_status) { 'ZERO_RESULTS' }

          it_behaves_like 'success response' do
            let(:enable_field_name_test) { false }
          end
          it { expect(subject.parsed_body['predictions']).to eq [] }
        end

        context 'and status is \'INVALID_REQUEST\'' do
          let(:response_status) { 'INVALID_REQUEST' }

          it_behaves_like 'failed response'
        end

        context 'and status is \'REQUEST_DENIED\'' do
          let(:response_status) { 'REQUEST_DENIED' }

          it_behaves_like 'failed response'
        end

        context 'and status is \'OVER_QUERY_LIMIT\'' do
          let(:response_status) { 'OVER_QUERY_LIMIT' }

          it_behaves_like 'failed response'
        end

        context 'and status is \'UNKNOWN_ERROR\'' do
          let(:response_status) { 'UNKNOWN_ERROR' }

          it_behaves_like 'failed response'
        end
      end

      context 'is missing' do
        let(:input) { nil }
        let(:response_status) { 'INVALID_REQUEST' }

        it_behaves_like 'failed response'
      end
    end
  end
end
