# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RidePresenter do
  let(:ride) { create(:ride) }

  describe 'MODEL_ATTRIBUTES constant' do
    subject { described_class::MODEL_ATTRIBUTES }
    it { is_expected.to eq %i[id requestor_id passengers date start_address end_address payment min_payment status] }
  end

  describe 'ride_requests_page_context' do
    subject { described_class.new(ride).page_context }

    it { is_expected.to be_instance_of Hash }

    let(:response) do
      {
        id: ride.id,
        requestor: ride.requestor.present.page_context,
        passengers: ride.passengers,
        date: ride.date,
        start_address: ride.start_address,
        end_address: ride.end_address,
        payment: ride.payment,
        min_payment: ride.min_payment,
        status: ride.status
      }
    end

    it 'returns Hash with expected fields' do
      expect(subject).to eq(response)
    end
  end

  describe 'delegates' do
    subject { described_class.new(ride) }

    RidePresenter::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
