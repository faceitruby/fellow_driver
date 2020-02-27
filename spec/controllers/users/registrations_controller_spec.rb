# frozen_string_literal: true

require 'rails_helper'
require 'support/shared/registration_controller_shared'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe 'route' do
    it { is_expected.to_not route(:get, '/api/users/signup').to(action: :index, format: :json) }
    it { is_expected.to_not route(:patch, '/api/users/signup').to(action: :show, format: :json) }
    it { is_expected.to_not route(:get, '/api/users/signup/sign_up').to(action: :new, format: :json) }
    it { is_expected.to_not route(:get, '/api/users/signup/edit').to(action: :edit, format: :json) }
    it { is_expected.to_not route(:delete, '/api/users/signup').to(action: :destroy, format: :json) }
    it { is_expected.to route(:post, '/api/users/signup').to(action: :create, format: :json) }
    it { is_expected.to route(:put, '/api/users/signup').to(action: :update, format: :json) }
    it { is_expected.to route(:patch, '/api/users/signup').to(action: :update, format: :json) }
  end

  describe 'POST#create' do
    before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

    let(:send_request) { post :create, params: params, as: :json }
    let(:params) do
      {
        user: {
          email: email,
          phone: phone
        }
      }
    end
    let(:email) { Faker::Internet.email }
    let(:phone) { Faker::Base.numerify('###-###-####') }

    it 'returns json' do
      send_request
      expect(response.content_type).to include('application/json')
    end

    context 'with user email' do
      let(:phone) { nil }

      it 'creates user' do
        expect { send_request }.to change(User, :count)
      end
      it 'gets 201 code' do
        send_request
        expect(response).to have_http_status(:created)
      end
    end
    context 'with user phone' do
      let(:email) { nil }

      it 'creates user' do
        expect { send_request }.to change(User, :count)
      end
      it 'gets 201 code' do
        send_request
        expect(response).to have_http_status(:created)
      end
    end
    context 'without user email and phone' do
      let(:email) { nil }
      let(:phone) { nil }

      it 'doesn\'t create user' do
        expect { send_request }.to_not change(User, :count)
      end
      it 'gets 422 code' do
        send_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST#update' do
    before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }

    let(:create_request) do
      post :create, params: { user: params[:user].slice(:email, :phone) }, as: :json
      request.headers['token'] = JSON.parse(response.body)['data']['token']
    end
    let(:update_request) { post :update, params: params, as: :json }
    let(:params) do
      {
        user: {
          email: email,
          phone: phone,
          first_name: first_name,
          last_name: last_name,
          address: address,
          avatar: avatar
        }
      }
    end
    let(:email) { Faker::Internet.email }
    let(:phone) { Faker::Base.numerify('###-###-####') }
    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }
    let(:address) { Faker::Address.full_address }
    # TODO: CHECK THAT ITS WORK
    let(:avatar) { Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']) }

    context 'with all fields' do
      it 'gets 204 code' do
        create_request
        update_request
        expect(response).to have_http_status(204)
      end
      # rubocop:disable Lint/AmbiguousBlockAssociation
      it 'changes user\'s fields' do
        create_request
        user = User.last
        expect do
          update_request
          user.reload
        end.to change { user.first_name }
          .and change { user.last_name }
          .and change { user.address }
      end
      # rubocop:enable Lint/AmbiguousBlockAssociation
    end
    context 'with missing address' do
      let(:address) { nil }

      it_behaves_like 'with missing fields'
    end
    context 'with missing avatar' do
      let(:avatar) { nil }

      it_behaves_like 'with missing fields'
    end
    context 'with missing email' do
      let(:email) { nil }

      it_behaves_like 'with missing fields'
    end
    context 'with missing phone' do
      let(:phone) { nil }

      it_behaves_like 'with missing fields'
    end
    context 'with missing first_name' do
      let(:first_name) { nil }

      it_behaves_like 'with missing fields'
    end
    context 'with missing last_name' do
      let(:last_name) { nil }

      it_behaves_like 'with missing fields'
    end
  end
end
