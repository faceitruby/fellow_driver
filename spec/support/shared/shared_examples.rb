# frozen_string_literal: true

RSpec.shared_examples 'with missing token' do
  subject { response }

  before { send_request }

  it { expect(response.content_type).to include('application/json') }
  it { is_expected.to have_http_status(:unauthorized) }
  it { expect(subject.parsed_body['success']).to be false }
  it { expect(subject.parsed_body['error']).to be_instance_of(String) && eq('Token is missing') }
end
