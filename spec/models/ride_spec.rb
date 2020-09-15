# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'columns' do
    %i[
      id requestor_id passengers status start_address end_address date payment min_payment created_at updated_at
    ].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:requestor).class_name('User') }
    it { is_expected.to have_many(:driver_candidates).dependent(:destroy) }
    it { is_expected.to have_one(:message).dependent(:destroy).inverse_of(:ride).class_name('RideMessage') }
  end

  describe 'validations' do
    let(:ride) { build :ride }

    %i[passengers start_address end_address date payment].each do |field|
      it { is_expected.to validate_presence_of field }
    end
    it { is_expected.to validate_numericality_of(:payment).is_greater_than_or_equal_to(ride.min_payment) }

    context 'when passengers do not exists' do
      let(:error) { ['Passenger does not exists'] }
      it do
        expect(ride.valid?).to be false
        expect(ride.errors.full_messages).to eq error
      end
    end
  end

  describe 'enums' do
    let(:statuses) { { created: 0, driver_found: 1, finished: 2, closed: 3 }.stringify_keys }

    it { is_expected.to define_enum_for :status }
    it { expect(described_class.statuses).to eq statuses }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for :message }
  end
end
