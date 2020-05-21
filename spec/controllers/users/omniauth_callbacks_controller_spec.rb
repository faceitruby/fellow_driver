# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'POST#facebook' do
    let(:params) { { access_token: 'token_sample' } }
    let(:send_request) { post :facebook, params: params, format: :json }
    let(:error) { ArgumentError }
    let(:user) { create(:user) }
    subject { response }

    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'when nothing raised' do
      let(:params) { { access_token: 'token' } }

      before do
        allow(Users::OmniauthFacebookService).to receive(:perform).and_return(user)
        send_request
      end

      it { is_expected.to have_http_status(:ok) }
      it { expect(subject.parsed_body).to be_instance_of Hash }
      it { expect(subject.parsed_body['success']).to eq true }
      it { expect(subject.parsed_body['token']).to be_present }
    end

    context 'when raised' do
      before do
        allow(Users::OmniauthFacebookService).to receive(:perform).and_raise(error)
        send_request
      end

      context 'ArgumentError' do
        it { is_expected.to have_http_status(:unprocessable_entity) }
      end
    end
  end
end
