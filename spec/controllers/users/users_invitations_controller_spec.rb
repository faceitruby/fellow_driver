# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:params) do
    # {
    #   "first_name": "Sergey",
    #   "last_name": "Magas",
    #   "phone": "123-456-7890",
    #   "email": "qwer@as.qw",
    #   "member_type": Family.member_types.keys.sample,
    #   "avatar": Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']),
    #   "address": "asdsd",
    #   "password": "password",
    #   "password_confirmation": "password",
    #   "invitation_token": "213213213"
    # }
    {
      "first_name": Faker::Name.first_name,
      "last_name": Faker::Name.last_name,
      "phone": Faker::Base.numerify('###-###-####'),
      "email": Faker::Internet.email,
      "member_type": Family.member_types.keys.sample,
      "avatar": Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']),
      "address": Faker::Address.full_address,
      "password": "password",
      "password_confirmation": "password"
    }
  end
  let(:send_post_request) { post :create, params: params.merge(user: user), as: :json }
  let(:send_put_request) { put :update, params: params.merge(user: user), as: :json }
  let(:send_incorrect_post_request) { post :create, params: params.merge(user: user, phone: nil), as: :json }

  describe 'POST#create' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      request.headers['token'] = token
      allow(Twilio::TwilioTextMessenger).to receive(:perform)
    end

    subject { send_post_request }

    xit 'returns json' do
      subject
      expect(response.content_type).to include('application/json')
    end
    it 'has status CREATED' do
      subject
      pp response
      expect(response).to have_http_status(:created)
    end

    # context 'when invites' do
    #   it 'creates user' do
    #     expect { subject }.to change(User, :count).by(1)
    #   end
    #
    #   it 'creates family' do
    #     expect { subject }.to change(Family, :count).by(1)
    #   end
    # end

    # context 'with correct request' do
    #   before { send_post_request }
    #   subject { response }
    #   it_behaves_like 'success action'
    # end
    #
    # context 'with incorrect request' do
    #   before { send_incorrect_post_request }
    #   subject { response }
    #   it_behaves_like 'failure action'
    # end
  end

  # describe 'PUT#update' do
  #   before do
  #     @request.env['devise.mapping'] = Devise.mappings[:user]
  #     request.headers['token'] = token
  #   end
  #
  #   subject { send_put_request }
  #
  #   it 'returns json' do
  #     subject
  #     pp response
  #     expect(response.content_type).to include('application/json')
  #   end
  #   it 'has status ACCEPTED' do
  #     subject
  #     expect(response).to have_http_status(:accepted)
  #   end
  # end
end
