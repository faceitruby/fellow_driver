# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::DistanceMatrixController, type: :controller do
  describe 'routes' do
    it { is_expected.to route(:post, '/api/users/distance_time/calculate').to(action: :calculate, format: :json) }
  end

  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
  let(:current_user) { create(:user) }

  before { request.headers.merge!(headers) }

  describe 'POST#calculate' do
    let(:send_request) do
      post :calculate,
           params: { distance: { origin: 'Inverdoorn Nature Reserve, Breede River DC, Южная Африка',
                                 destination: 'проспект Соборный, 169, Запорожье, Запорожская область, Украина' } },
           format: :json
    end
    let(:distances) do
      {
        "distance_text": '16,020 km',
        "distance_in_meters": 16_020_180,
        "duration_text": '8 days 15 hours',
        "duration_in_seconds": 745_007
      }
    end
    let(:expected_response) { { success: true, data: distances } }

    before do
      allow(Users::DistanceMatrixService).to receive(:perform).and_return(distances)
      send_request
    end

    it { expect(response.content_type).to include('application/json') }
    it { expect(response).to have_http_status(:success) }
    it 'render JSON with list of favourite places' do
      expect(response.body).to eq(expected_response.to_json)
    end
  end
end
