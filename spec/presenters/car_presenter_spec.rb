# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarPresenter do
  context 'contain fields' do
    %i[manufacturer model year color license_plat_number].each do |field|
      it { expect(CarPresenter::MODEL_ATTRIBUTES).to include field }
    end
  end

  context '#cars_page_context' do
    let(:car) { build(:car) }
    subject { CarPresenter.new(car).cars_page_context }

    it { expect(subject.class).to eq(String) }
    it 'returns JSON compatible string' do
      expect { JSON.parse subject }.to_not raise_error(JSON::ParserError)
    end
  end

  describe 'methods' do
    let(:car) { build(:car) }
    subject { CarPresenter.new(car) }

    CarPresenter::MODEL_ATTRIBUTES.each do |field|
      it { is_expected.to respond_to(field) }
    end
  end
end
