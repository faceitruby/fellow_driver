# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::CreateService do
  let(:date) { Date.tomorrow }
  let(:current_user) { create(:user) }
  let(:payment) { Faker::Number.within(range: 10..100) }
  let(:addresses) { Array.new(2) { Faker::Address.full_address } }
  let(:message) { Faker::Lorem.sentence }
  let(:template_id) { RideTemplate.first.id }
  let(:passengers) { create_list(:user, 3, :create).pluck(:id) }
  let(:ride_message_attributes) do
    {
      message: message,
      ride_template_id: template_id
    }
  end
  let(:params) do
    {
      passengers: passengers,
      date: date.to_s,
      start_address: addresses.first,
      end_address: addresses.second,
      payment: payment,
      requestor: current_user,
      message_attributes: ride_message_attributes
    }
  end

  before { Rails.application.load_seed }

  subject { described_class.perform(params) }

  describe '#call' do
    context 'when message with custom message' do
      let(:template_id) { nil }

      it { is_expected.to be_instance_of Ride }
    end

    context 'when message with template_id' do
      let(:message) { nil }

      it { is_expected.to be_instance_of Ride }
    end

    context 'with missing' do
      let(:template_id) { nil }
      { passengers: 'Validation failed: Passengers can\'t be blank',
        start_address: 'Validation failed: Start address can\'t be blank',
        end_address: 'Validation failed: End address can\'t be blank',
        date: 'Validation failed: Date can\'t be blank',
        payment: 'Validation failed: Payment can\'t be blank, Payment is not a number' }.each do |field, description|
        context field.to_s do
          let(:params) { super().except(field) }

          it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid, description) }
        end
      end
    end

    context 'with message and template_id both provided' do
      # TODO: CHECK WHY MESSAGE IS SO STRANGE
      let(:description) { 'Validation failed: Message message or template can\'t be both present at once' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid, description) }
    end

    context 'with message and template_id both missing' do
      let(:ride_message_attributes) { {} }
      # TODO: CHECK WHY MESSAGE IS SO STRANGE
      let(:description) { 'Validation failed: Message message and template are missing' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid, description) }
    end

    context 'with low payment' do
      let(:message) { nil }
      let(:payment) { 1 }
      let(:description) { 'Validation failed: Payment must be greater than or equal to 10' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid, description) }
    end
  end
end
