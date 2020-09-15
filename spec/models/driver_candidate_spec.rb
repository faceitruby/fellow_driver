# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DriverCandidate, type: :model do
  describe 'columns' do
    %i[id driver_id second_connection created_at updated_at ride_id status].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:driver).class_name('User') }
    it { is_expected.to belong_to(:ride) }
  end

  describe 'validations' do
    context 'when accepted candidates is absent' do
      let(:candidate) { build :driver_candidate, :accepted }

      it { expect(candidate).to be_valid }
    end

    context 'when accepted candidate exists' do
      let!(:existing_candidate) { create :driver_candidate, :accepted }
      let(:candidate) do
        build :driver_candidate, :accepted, ride: existing_candidate.ride, driver: existing_candidate.driver
      end

      it { expect(candidate).to_not be_valid }
    end
  end

  describe 'enums' do
    let(:statuses) { { created: 0, accepted: 1, dismissed_by_requestor: 2, dismissed_by_candidate: 3 } }

    it { is_expected.to define_enum_for :status }
    it { expect(described_class.statuses).to eq statuses.stringify_keys }
  end
end
