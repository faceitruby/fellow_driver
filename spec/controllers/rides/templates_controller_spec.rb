# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::TemplatesController, type: :controller do
  let(:send_request) { get :index, params: params }
  let(:current_user) { create(:user) }
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, current_user) }
  let(:params) do
    {
      message_info: {
        time: time,
        start_address: Faker::Address.full_address,
        end_address: Faker::Address.full_address,
        passengers: [current_user.id]
      }
    }
  end
  let(:field_name) { 'message_templates' }

  describe 'routes' do
    it do
      is_expected.to route(:get, '/api/templates').to(controller: 'rides/templates',
                                                      action: :index, format: :json)
    end
    it do
      is_expected.to route(:get, '/api/rides/1/template').to(controller: 'rides/templates',
                                                             action: :show, format: :json, id: 1)
    end
  end

  describe 'GET#index' do
    before do
      request.headers.merge! headers
      Rails.application.load_seed
      send_request
    end

    context 'with time in future' do
      let(:time) { (Time.current + 30.minutes).to_s }

      include_examples 'success response'
      it { expect(response.parsed_body['message_templates']).to be_present && be_an_instance_of(Array) }
    end

    context 'with current time' do
      let(:time) { Time.current.to_s }
      let(:message) { 'Date must be in a future' }

      include_examples 'failed response'
      it { expect(response.parsed_body['error']).to eq message }
    end

    context 'with wrong time' do
      let(:time) { '2020-20-23 11:30:00' }
      let(:message) { 'Wrong time' }

      include_examples 'failed response'
      it { expect(response.parsed_body['error']).to eq message }
    end

    context 'when token is missing' do
      let(:headers) { {} }
      let(:time) { (Time.current + 30.minutes).to_s }

      include_examples 'with missing token'
      it { expect(response.parsed_body['error']).to eq message }
    end
  end

  describe 'GET#show' do
    let(:params) { { id: ride.id } }
    let(:send_request) { get :show, params: params }
    let(:field_name) { 'message_template' }

    before do
      request.headers.merge! headers
      Rails.application.load_seed
      send_request
    end

    context 'with correct params' do
      let(:ride) { create :ride, :message_with_template }

      include_examples 'success response'
    end

    context 'when ride request without template' do
      let(:ride) { create :ride }

      include_examples 'failed response'
    end

    context 'when token is missing' do
      let(:headers) { {} }
      let(:params) { { id: Faker::Number.number } }
      let(:time) { (Time.current + 30.minutes).to_s }

      include_examples 'with missing token'
    end
  end
end
