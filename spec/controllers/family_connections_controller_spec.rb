# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamilyConnectionsController, type: :controller do
  let(:user) { create(:user, email: 'user@example.com') }
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }
  let(:requestor_user) { create(:user) }
  let!(:family_connection) { create(:family_connection, requestor_user: requestor_user, receiver_user: user) }
  before { request.headers.merge! headers }

  describe 'GET#index' do
    let(:send_request) { get :index, format: :json }
    context 'with one connection' do
      before { send_request }
      subject { response }

      %i[id requestor_user_id receiver_user_id].each do |field|
        it { expect(response.parsed_body.first[field.to_s]).to eq(family_connection[field.to_s]) }
      end
      it_behaves_like 'is an array with length as current_user family_connections length'
    end

    context 'with two connections' do
      let(:requestor_user_2) { create(:user) }
      let!(:connection_2) { create(:family_connection, requestor_user: requestor_user_2, receiver_user: user) }

      before { send_request }
      subject { response }

      %i[id requestor_user_id receiver_user_id].each do |field|
        it { expect(response.parsed_body.first[field.to_s]).to eq(family_connection[field.to_s]) }
        it { expect(response.parsed_body.last[field.to_s]).to eq(connection_2[field.to_s]) }
      end
      it_behaves_like 'is an array with length as current_user family_connections length'
    end

    context 'with missing token' do
      let(:headers) { {} }

      it_behaves_like 'with missing token'
    end
  end

  describe 'PUT#update' do
    let(:send_request) do
      put :update,
          params: { id: family_connection.id,
                    current_user: user },
          as: :json
    end

    context 'with valid params' do
      before { send_request }
      subject { response }

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'with missing token' do
      let(:headers) { {} }

      it_behaves_like 'with missing token'
    end
  end
end
