# frozen_string_literal: true

require 'rails_helper'
require 'support/shared/results_shared'

RSpec.describe Users::SessionsController, type: :controller do
  describe 'routes' do
    it { is_expected.not_to route(:get, '/api/users/login').to(action: :new, format: :json) }
    it { is_expected.not_to route(:delete, '/api/users/login').to(action: :destroy, format: :json) }
    it { is_expected.to route(:post, '/api/users/login').to(action: :create, format: :json) }
  end

  describe 'POST#create' do
    before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }
    subject { post :create, params: params, as: :json }

    context 'when login is an email ' do
      let(:user) { create(:user, :create_params_only, phone: nil, password: 'password') }
      let(:params) { { user: { login: user.email, password: 'password' } } }

      it 'gets 200 code' do
        subject
        expect(response).to have_http_status(200)
      end
      it_behaves_like 'render success response'
    end
    context 'when login is an phone' do
      let(:user) { create(:user, :create_params_only, email: nil, password: 'password') }
      let(:params) { { user: { login: user.phone, password: 'password' } } }

      it 'gets 200 code' do
        subject
        expect(response).to have_http_status(200)
      end
      it_behaves_like 'render success response'
    end
    context 'when login missing' do
      let(:user) { create(:user, :create_params_only, email: nil, password: 'password') }
      let(:params) { { user: { password: 'password' } } }

      it 'gets 422 code' do
        subject
        expect(response).to have_http_status(422)
      end
      it_behaves_like 'render error response'
    end
    context 'when password missing' do
      let(:user) { create(:user, :create_params_only, email: nil, password: 'password') }
      let(:params) { { user: { login: user.phone } } }

      it 'gets 422 code' do
        subject
        expect(response).to have_http_status(422)
      end
      it_behaves_like 'render error response'
    end
  end
end
