# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RideTemplate, type: :model do
  describe 'columns' do
    %i[id text created_at updated_at].each do |column|
      it { is_expected.to have_db_column column }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:messages).class_name('RideMessage').dependent(:nullify) }
  end

  describe 'validation' do
    subject { create :ride_template }

    it { is_expected.to validate_uniqueness_of :text }
    it { is_expected.to validate_presence_of :text }
  end
end
