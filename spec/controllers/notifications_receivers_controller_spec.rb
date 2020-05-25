require 'rails_helper'

RSpec.describe NotificationsReceiversController, type: :controller do
  describe 'routes' do
    it 'have notifications create route' do
      expect(post: '/api/notifications_receivers')
        .to route_to(controller: 'notifications_receivers', format: :json, action: 'create')
    end

    it 'have notifications destroy route' do
      expect(delete: '/api/notifications_receivers')
        .to route_to(controller: 'notifications_receivers', format: :json, action: 'destroy')
    end
  end

  describe 'POST#create' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }
    let(:send_request) { post :create, params: {} }

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(user.notifications_enabled).to eq(true) }
  end

  describe 'DELETE#destroy' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }
    let(:send_request) { delete :destroy, params: { id: user.id } }

    before do
      request.headers['token'] = token
      send_request
    end

    it { expect(User.find(user.id).notifications_enabled).to eq(false) }
  end
end
