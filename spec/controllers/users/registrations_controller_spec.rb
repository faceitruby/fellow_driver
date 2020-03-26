# frozen_string_literal: true

require 'rails_helper'
require 'json_web_token'

# Update user examples
RSpec.shared_examples 'update with missing fields' do
  it 'gets 422 code' do
    send_request
    expect(response).to have_http_status(422)
  end
  it 'doesn\'t change user\'s fields' do
    user = User.last
    expect do
      send_request
      user.reload
    end.to not_change(user, :phone)
      .and not_change(user, :first_name)
      .and not_change(user, :last_name)
      .and not_change(user, :address)
  end
end

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
    let(:send_request) { post :create, params: params, as: :json }
    let(:params) do
      {
        user: {
          email: email,
          phone: phone,
          password: password
        }
      }
    end
    let(:email) { Faker::Internet.email }
    let(:phone) { Faker::Base.numerify('###-###-####') }
    let(:password) { 'password' }

    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    it 'returns json' do
      send_request
      expect(response.content_type).to include('application/json')
    end

    context 'with user email' do
      let(:phone) { nil }

      it 'creates user' do
        expect { send_request }.to change(User, :count).by(1)
      end
      it 'gets 201 code' do
        send_request
        expect(response).to have_http_status(:created)
      end
    end

    context 'with user phone' do
      let(:email) { nil }

      it 'creates user' do
        expect { send_request }.to change(User, :count).by(1)
      end
      it 'gets 201 code' do
        send_request
        expect(response).to have_http_status(:created)
      end
    end

    context 'with missing password' do
      let(:password) { nil }

      it 'doesn\'t create user' do
        expect { send_request }.to_not change(User, :count)
      end
      it 'gets 422 code' do
        send_request
        expect(response).to have_http_status(422)
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
    let!(:user) { create(:user, :create, phone: nil) }
    let(:send_request) { post :update, params: params, as: :json }
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
    let(:avatar) { Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']) }

    before do |test|
      @request.env['devise.mapping'] = Devise.mappings[:user]
      unless test.metadata[:real_token]
        allow(controller).to receive(:check_authorize).and_return(nil)
        allow_any_instance_of(Users::Registration::UpdateService).to receive(:user).and_return(user)
      end
    end

    context 'with all fields provided' do
      it 'gets 204 code' do
        send_request
        expect(response).to have_http_status(204)
      end
      it 'changes user\'s fields' do
        expect do
          send_request
          user.reload
        end.to change(user, :first_name)
          .and change(user, :last_name)
          .and change(user, :address)
      end
    end

    %i[address avatar email phone first_name last_name].each do |field|
      context "with missing #{field}" do
        let(field) { nil }

        it_behaves_like 'update with missing fields'
      end
    end

    context 'with missing token', :real_token do
      it 'gets 401 code' do
        send_request
        expect(response).to have_http_status(401)
      end
    end

    context 'with wrong token', :real_token do
      it 'gets 422 code' do
        @request.headers['token'] = 'wrong_token'
        send_request
        expect(response).to have_http_status(422)
      end
    end

    context 'with correct token', :real_token do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      it 'gets 204 code' do
        @request.headers['token'] = token
        send_request
        expect(response).to have_http_status(204)
      end
    end
  end
end
