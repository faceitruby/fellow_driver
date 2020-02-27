# frozen_string_literal: true

RSpec.shared_examples 'with missing fields' do
  it 'gets 422 code' do
    create_request
    update_request
    expect(response).to have_http_status(422)
  end
  # rubocop:disable Lint/AmbiguousBlockAssociation
  it 'doesn\'t change user\'s fields' do
    create_request
    user = User.last
    expect do
      update_request
      user.reload
    end.to not_change { user.phone }
      .and not_change { user.first_name }
      .and not_change { user.last_name }
      .and not_change { user.address }
  end
  # rubocop:enable Lint/AmbiguousBlockAssociation
end
