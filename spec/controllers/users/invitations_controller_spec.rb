# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
  let(:params) { { user: attributes_for(:user, :random_member) } }
  let(:user) { create(:user, :random_member) }
  let(:requestor_user) { create(:user) }

  before { request.headers.merge! headers }

  describe 'POST#create' do
    context 'with existing user' do
      let(:existing_user) { create(:user, email: 'user@example.com') }
      let(:params_2) { { user: attributes_for(:user, :random_member, email: 'user@example.com') } }
      let(:send_request_2) do
        post :create, params: params_2.merge(
          requestor_user: current_user,
          receiver_user: existing_user
        ), as: :json
      end
      subject { response }

      context 'with correct parameters' do
        let(:connection) { create(:family_connection, requestor_user: requestor_user, receiver_user: user) }
        before do
          allow(Connections::FamilyConnections::CreateService).to receive(:perform).and_return(connection)
          send_request_2
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(subject.parsed_body['success']).to be true }
        it { expect(subject.parsed_body['connection']).to be_present && be_instance_of(Hash) }
      end

      context 'when raised' do
        let(:error) { ActiveRecord::RecordInvalid }
        before do
          allow(Connections::FamilyConnections::CreateService).to receive(:perform).and_raise(error)
          send_request_2
        end

        it_behaves_like 'with raised error'
      end
    end

    context 'with new user' do
      let(:send_request) { post :create, params: params.merge(current_user: current_user), as: :json }
      let(:user) do
        User.invite!(params[:user].merge(skip_invitation: true, family_id: current_user.family.id), current_user)
      end
      subject { response }

      context 'with correct params' do
        before do
          send_request
          allow(Users::InvitationService).to receive(:perform)
            .and_return(user)
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

          it_behaves_like 'with raised error'
        end
      end

      context 'with missing token' do
        let(:headers) { {} }

        it_behaves_like 'with missing token'
      end
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
      let(:update_params) { { user: params[:user].merge(invitation_token: user.raw_invitation_token) } }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:accepted) }
    end

    context 'with invalid token' do
      let(:update_params) { { user: params[:user].merge(invitation_token: 'some_token') } }

      it { expect(response.content_type).to include('application/json') }
      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end
end
