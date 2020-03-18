# frozen_string_literal: true

# OpenStruct returned from services
RSpec.shared_examples 'provided fields' do
  it 'returns correct params' do
    expect(subject.success?).to be true
    expect(subject.data).to be_present
    expect(subject.errors).to_not be_present
  end
end

RSpec.shared_examples 'missing fields' do
  it 'returns correct params' do
    expect(subject.success?).to be false
    expect(subject.data).to_not be_present
    expect(subject.user).to_not be_present
    expect(subject.errors).to be_present
  end
end

# JSON rendered from controllers
RSpec.shared_examples 'success action' do
  it 'returns correct params' do
    expect(subject.parsed_body['success']).to be true
    expect(subject.parsed_body['data']).to be_present
    expect(subject.parsed_body['message']).to_not be_present
  end
end

RSpec.shared_examples 'failure action' do
  it 'returns correct params' do
    expect(subject.parsed_body['success']).to be false
    expect(subject.parsed_body['data']).to_not be_present
    expect(subject.parsed_body['message']).to be_present
  end
end
