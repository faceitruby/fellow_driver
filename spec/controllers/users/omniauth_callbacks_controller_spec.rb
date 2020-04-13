# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'POST#facebook' do
    let(:params) { { access_token: 'token_sample' } }
    let(:send_request) { post :facebook, params: params, format: :json }
    subject { response }

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      expect(Users::OmniauthFacebookService).to receive(:perform).and_return(result)
      send_request
    end

    context 'when success? is true' do
      let(:result) { OpenStruct.new(success?: true, data: { user: attributes_for(:user, :create), errors: nil }) }

      it { is_expected.to have_http_status(200) }
      it_behaves_like 'success action'
    end

    context 'when success? is false' do
      let(:result) { OpenStruct.new(success?: false, data: nil, errors: 'error') }

      it { is_expected.to have_http_status(400) }
      it_behaves_like 'failure action'
    end
  end
end
