# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarPresenter do
  let(:car) { build(:car) }

  describe 'MODEL_ATTRIBUTES constant' do
    subject { described_class::MODEL_ATTRIBUTES }
    it { is_expected.to eq %i[manufacturer model year color license_plat_number] }
  end

  describe '#cars_page_context' do
    subject { described_class.new(car).cars_page_context }

    it { is_expected.to be_instance_of Hash }

    let(:response) do
      {
        manufacturer: car.manufacturer,
        model: car.model,
        year: car.year,
        color: car.color,
        license_plat_number: car.license_plat_number
      }
    end

    it 'returns Hash with expected fields' do
      expect(subject).to eq(response)
    end
  end

  describe 'delegates' do
    subject { described_class.new(car) }

    CarPresenter::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
