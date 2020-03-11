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

# Update user examples
RSpec.shared_examples 'update with missing fields' do
  it 'gets 422 code' do
    update_request
    expect(response).to have_http_status(422)
  end
  it 'doesn\'t change user\'s fields' do
    user = User.last
    expect do
      update_request
      user.reload
    end.to not_change(user, :phone)
      .and not_change(user, :first_name)
      .and not_change(user, :last_name)
      .and not_change(user, :address)
  end
end
