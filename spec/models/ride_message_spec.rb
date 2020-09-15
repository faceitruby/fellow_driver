# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RideMessage, type: :model do
  describe 'columns' do
    %i[id updated_at created_at message ride_template_id ride_id].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    it do
      is_expected.to belong_to(:template).class_name('RideTemplate')
                                         .with_foreign_key('ride_template_id').optional(true)
    end
    it { is_expected.to belong_to(:ride) }
  end

  describe 'validations' do
    context 'when message provided' do
      let(:ride_message) { build :ride_message }

      it { expect(ride_message).to be_valid }
    end

    context 'when template provided' do
      let(:ride_message) { build :ride_message, :template }

      it { expect(ride_message).to be_valid }
    end

    context 'when message and template both provided' do
      let(:ride_message) { build :ride_message, :template, message: Faker::Lorem.sentence }
      let(:error) { ['Message or template can\'t be both present at once'] }

      it do
        expect(ride_message).to_not be_valid
        expect(ride_message.errors.full_messages).to eq error
      end
    end

    context 'when message and template both are missing' do
      let(:ride_message) { build :ride_message, template: nil, message: nil }
      let(:error) { ['Message and template are missing'] }

      it do
        expect(ride_message).to_not be_valid
        expect(ride_message.errors.full_messages).to eq error
      end
    end
  end
end
