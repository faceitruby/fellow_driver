# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicePresenter do
  let(:device) { build(:device) }

  describe 'MODEL_ATTRIBUTES constant' do
    subject { described_class::MODEL_ATTRIBUTES }
    it { is_expected.to eq %i[id user_id registration_ids platform created_at updated_at] }
  end

  describe '#devices_page_context' do
    subject { described_class.new(device).device_page_context }

    it { is_expected.to be_instance_of Hash }

    let(:response) do
      {
        id: device.id,
        platform: device.platform,
        registration_ids: device.registration_ids,
        user_id: device.user_id,
        created_at: device.created_at,
        updated_at: device.updated_at
      }
    end

    it 'returns Hash with expected fields' do
      expect(subject).to eq(response)
    end
  end

  describe 'delegates' do
    subject { described_class.new(device) }

    DevicePresenter::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
