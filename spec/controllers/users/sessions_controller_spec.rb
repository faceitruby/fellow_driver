require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  it { is_expected.to route(:post, '/api/users/login').to(action: :create, format: :json) }
end
