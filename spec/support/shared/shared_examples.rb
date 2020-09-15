# frozen_string_literal: true

RSpec.shared_examples 'with missing token' do
  let(:message) { 'Token is missing.' }
  subject { response }

  before { send_request }

  it 'behaves as request with missing token' do
    expect(response.content_type).to include('application/json')
    is_expected.to have_http_status(:unauthorized)
    expect(subject.parsed_body['success']).to be false
    expect(subject.parsed_body['error']).to be_instance_of(String) && eq(message)
  end
end

RSpec.shared_examples 'success response' do
  let(:status) { :ok }
  let(:enable_field_name_test) { true }

  subject { response }

  it 'behaves as success response' do
    expect(response.content_type).to include('application/json')
    is_expected.to have_http_status(status)
    expect(subject.parsed_body['success']).to be true
    expect(subject.parsed_body['error']).to_not be_present
    expect(subject.parsed_body[field_name]).to(be_present) if enable_field_name_test
  end
end

RSpec.shared_examples 'failed response' do
  let(:status) { :unprocessable_entity }
  let(:enable_field_name_test) { true }

  subject { response }

  it 'behaves as failed response' do
    expect(response.content_type).to include('application/json')
    is_expected.to have_http_status(status)
    expect(subject.parsed_body['success']).to be false
    expect(subject.parsed_body['error']).to be_present
    expect(subject.parsed_body[field_name]).to_not(be_present) if enable_field_name_test
  end
end
