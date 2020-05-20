# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe 'routes' do
    it { is_expected.not_to route(:get, '/api/users/login').to(action: :new, format: :json) }
    it { is_expected.not_to route(:delete, '/api/users/login').to(action: :destroy, format: :json) }
    it { is_expected.to route(:post, '/api/users/login').to(action: :create, format: :json) }
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: params, as: :json }
    subject { response }

    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when login' do
      before { send_request }

      context 'is an email' do
        let(:user) { create(:user, :create, phone: nil, password: 'password') }
        let(:params) { { user: { login: user.email, password: 'password' } } }

        it { is_expected.to have_http_status(200) }
        it_behaves_like 'success action'
      end

      context 'is an phone' do
        let(:user) { create(:user, :create, email: nil, password: 'password') }
        let(:params) { { user: { login: user.phone, password: 'password' } } }

        it { is_expected.to have_http_status(200) }
        it_behaves_like 'success action'
      end

      context 'is missing' do
        let(:user) { create(:user, :create, email: nil, password: 'password') }
        let(:params) { { user: { password: 'password' } } }

        it { is_expected.to have_http_status(422) }
        it_behaves_like 'failure action'
      end
    end

    context 'when password is missing' do
      let(:user) { create(:user, :create, email: nil, password: 'password') }
      let(:params) { { user: { login: user.phone } } }

      before { send_request }

      it { is_expected.to have_http_status(422) }
      it_behaves_like 'failure action'
    end
  end
end
