require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  context 'routing' do
    context 'have' do
      it do
        expect(post: '/api/payments').to route_to(
          controller: 'payments',
          format: :json,
          action: 'create'
        )
      end
    end
  end

  context 'actions' do
    let(:user) { create(:user, :correct_user_update) }
    let(:token) { JsonWebToken.encode(user_id: user.instance_of?(String) ? user : user.id) }
    it 'createn new payment method' do
      request.headers['token'] = token
      VCR.use_cassette('create_payment') do
        expect do
          post :create, params: {
            type: 'card',
            card: {
              number: '4000 0000 0000 2230',
              exp_month: 2,
              exp_year: 2021,
              cvc: '314'
            }
          }
        end.to change(Payment, :count).by(1)
      end
    end

    it 'do not new payment method' do
      request.headers['token'] = token
      VCR.use_cassette('dont_create_payment') do
        expect do
          post :create, params: {
            type: 'card',
            card: {
              number: '4000 00100 0000 2230',
              exp_month: 2,
              exp_year: 2021,
              cvc: '314'
            }
          }
        end.to change(Payment, :count).by(0)
      end
    end
  end
end
