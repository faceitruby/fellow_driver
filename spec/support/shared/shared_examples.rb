# frozen_string_literal: true

RSpec.shared_examples 'with missing token' do
  let(:message) { 'Token is missing.' }
  subject { response }

  before { send_request }

  it { expect(response.content_type).to include('application/json') }
  it { is_expected.to have_http_status(:unauthorized) }
  it { expect(subject.parsed_body['success']).to be false }
  it { expect(subject.parsed_body['error']).to be_instance_of(String) && eq(message) }
end

RSpec.shared_examples 'with raised error' do
  it { expect(response.content_type).to include('application/json') }
  it { is_expected.to have_http_status(:unprocessable_entity) }
  it { expect(subject.parsed_body['success']).to be false }
  it { expect(subject.parsed_body['error']).to be_present && be_instance_of(String) }
end

RSpec.shared_examples 'is an array with length as current_user family_connections length' do
  it { expect(response.parsed_body).to be_a_kind_of(Array) }
  it { expect(response.parsed_body.length).to eq(user.receiver_user_family_connections.length) }
end
