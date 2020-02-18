# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe 'route' do
    it { is_expected.to route(:post, '/api/users/signup').to(action: :create, format: :json) }
  end
  describe 'action' do
    before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

    let(:create_user_with_email) do
      post :create, params: { user: { email: 'user@example.com', password: 'password' } }, as: :json
    end
    let(:create_user_with_phone) do
      post :create, params: { user: { phone: '123-456-7890', password: 'password' } }, as: :json
    end
    let(:create_user_without_phone_email) { post :create, params: { user: { password: 'password' } }, as: :json }

    describe '#create' do
      it 'user with email changes User count' do
        expect { create_user_with_email }.to change(User, :count)
      end
      it 'user with phone changes User count' do
        expect { create_user_with_phone }.to change(User, :count)
      end
      it 'user without email and phone does not change User count' do
        expect { create_user_without_phone_email }.to_not change(User, :count)
      end
      context 'gets status' do
        it '201 when user has email' do
          create_user_with_email
          expect(response).to have_http_status(:created)
        end
        it '201 when user has phone' do
          create_user_with_phone
          expect(response).to have_http_status(:created)
        end
        it '422 when user does not have phone and email' do
          create_user_without_phone_email
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      context 'response' do
        it 'contain json' do
          create_user_with_email
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe '#update' do
      let(:correct_params) { { user: attributes_for(:correct_user_update) } }
      let(:wrong_params) { { user: attributes_for(:user_with_missing_fields_update) } }
      before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

      context 'gets status' do
        let(:user) { create(:user_email_only) }

        let(:correct_update_request) do
          put :update, headers: { token: request.headers['token'] }
        end

        it '204 with correct update request' do
          post :create, params: { user: { email: 'user@example.com', password: 'password' } }, as: :json
          request.headers['token'] = JSON.parse(response.body)['data']['token']
          put :update, params: correct_params
          expect(response).to have_http_status(204)
        end
        it '422 with wrong update request' do
          post :create, params: { user: { email: 'user@example.com', password: 'password' } }, as: :json
          request.headers['token'] = JSON.parse(response.body)['data']['token']
          put :update, params: wrong_params
          expect(response).to have_http_status(422)
        end
      end
      context 'action' do
        it 'changes user`s fields with correct params' do
          post :create, params: { user: { email: 'user1@example.com', password: 'password' } }, as: :json
          request.headers['token'] = JSON.parse(response.body)['data']['token']
          user = User.last
          expect do
            put :update, params: correct_params
            user.reload
          end.to change { user.phone }
                 .and change { user.first_name }
                 .and change { user.last_name }
                 .and change { user.address }
        end
        it 'does not change user`s fields with correct params' do
          post :create, params: { user: { email: 'user1@example.com', password: 'password' } }, as: :json
          request.headers['token'] = JSON.parse(response.body)['data']['token']
          user = User.last
          expect do
            put :update, params: wrong_params
            user.reload
          end.to not_change { user.phone }
             .and not_change { user.first_name }
             .and not_change { user.last_name }
             .and not_change { user.address }
        end
      end
    end
  end
end
