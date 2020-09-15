# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
  let(:params) { { user: attributes_for(:user, :random_member) } }

  before { request.headers.merge! headers }

  describe 'callbacks' do
    it { is_expected.to use_before_action(:authenticate_user!) }
  end

  describe 'POST#create' do
    let(:send_request) { post :create, params: params.merge(current_user: current_user), as: :json }
    let(:user) do
      User.invite!(params[:user].merge(skip_invitation: true, family_id: current_user.family.id), current_user)
    end
    subject { response }

    context 'with correct params' do
      before do
        allow(Users::InvitationService).to receive(:perform)
          .with(instance_of(ActionController::Parameters))
          .and_return(user)
        allow(controller).to receive(:current_user).and_return(current_user)
        send_request
      end

      it { expect(response).to have_http_status(:created) }
      it { expect(subject.parsed_body['success']).to be true }
      it { expect(subject.parsed_body['invite_token']).to be_present && be_instance_of(String) }
      it { expect(subject.parsed_body['user']).to be_present && be_instance_of(Hash) }
    end

    context 'when raised' do
      before do
        allow(Users::InvitationService).to receive(:perform).and_raise(error)
        send_request
      end

      context 'ActiveRecord::RecordInvalid' do
        let(:error) { ActiveRecord::RecordInvalid }

        it { expect(response.content_type).to include('application/json') }
        it { is_expected.to have_http_status(:unprocessable_entity) }
        it { expect(subject.parsed_body['success']).to be false }
        it { expect(subject.parsed_body['error']).to be_present && be_instance_of(String) }
      end
    end

    context 'with missing token' do
      let(:headers) { {} }

      it_behaves_like 'with missing token'
    end
  end

  describe 'PUT#update' do
    let(:user) { create(:user, skip_invitation: true) }
    let(:send_request) do
      put :update,
          params: update_params,
          as: :json
    end

    before do
      user.invite!(current_user)
      send_request
    end

    subject { response }

    context 'with correct token' do
      let(:update_params) do
        {
          user: params[:user].merge(invitation_token: user.raw_invitation_token)
        }
      end

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:accepted) }
    end

    context 'with invalid token' do
      let(:update_params) do
        {
          user: params[:user].merge(invitation_token: 'some_token')
        }
      end

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end
end
