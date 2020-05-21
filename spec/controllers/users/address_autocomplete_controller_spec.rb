# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'success response' do
  it { is_expected.to have_http_status(:ok) }
  it { expect(subject.content_type).to include('application/json') }
  it { expect(subject.parsed_body['success']).to be true }
end

RSpec.shared_examples 'failure response' do
  it { is_expected.to have_http_status(:unprocessable_entity) }
  it { expect(subject.content_type).to include('application/json') }
  it { expect(subject.parsed_body['success']).to be false }
  it { expect(subject.parsed_body['error']).to be_instance_of(String) && be_present }
end

RSpec.describe Users::AddressAutocompleteController, type: :controller do
  describe 'routes' do
    it { is_expected.to route(:post, '/api/users/address_autocomplete/complete').to(action: :complete, format: :json) }
  end

  describe 'POST#complete' do
    let(:body) do
      {
        predictions: predictions,
        status: status
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
    subject { response }

    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when token is missing' do
      before { send_request }

      # it { is_expected.to have_http_status(:unauthorized) }
      it_behaves_like 'with missing token'
    end

    context 'when input' do
      before do
        allow(controller).to receive(:check_authorize).and_return(nil)
        allow_any_instance_of(GooglePlacesAutocomplete::Client).to receive(:autocomplete).with(an_instance_of(Hash))
                                                                                         .and_return(result)
        send_request
      end

      context 'is present' do
        context 'and returned status is \'OK\'' do
          let(:predictions) { [{ description: 'Some Place' }] }
          let(:status) { 'OK' }

          it_behaves_like 'success response'
          it { expect(subject.parsed_body['predictions']).to be_instance_of(Array) && be_present }
        end

        context 'and returned status is \'ZERO_RESULTS\'' do
          let(:status) { 'ZERO_RESULTS' }

          it_behaves_like 'success response'
          it { expect(subject.parsed_body['predictions']).to eq [] }
        end

        context 'and status is \'INVALID_REQUEST\'' do
          let(:status) { 'INVALID_REQUEST' }

          it_behaves_like 'failure response'
        end

        context 'and status is \'REQUEST_DENIED\'' do
          let(:status) { 'REQUEST_DENIED' }

          it_behaves_like 'failure response'
        end

        context 'and status is \'OVER_QUERY_LIMIT\'' do
          let(:status) { 'OVER_QUERY_LIMIT' }

          it_behaves_like 'failure response'
        end

        context 'and status is \'UNKNOWN_ERROR\'' do
          let(:status) { 'UNKNOWN_ERROR' }

          it_behaves_like 'failure response'
        end
      end

      context 'is missing' do
        let(:input) { nil }
        let(:status) { 'INVALID_REQUEST' }

        it_behaves_like 'failure response'
      end
    end
  end
end
