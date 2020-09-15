# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::Messages::TemplatesService do
  let(:users) { build_list :user, 2 }
  let(:params) do
    {
      id: Faker::Number.number,
      time: Time.current,
      start_address: Faker::Address.full_address,
      end_address: Faker::Address.full_address,
      passengers: [1, 2]
    }
  end
  let(:relation_result) do
    [
      { relation: 'son', name: users[0].first_name },
      { relation: 'daughter', name: users[1].first_name }
    ]
  end

  subject { described_class.perform(params) }

  describe 'call' do
    before { allow(FamilyMembers::FetchRelationService).to receive(:perform).and_return(relation_result) }

    context 'with all params' do
      it { is_expected.to eq nil }
      it { expect { subject }.to_not raise_error }
    end

    context 'with missing' do
      {   passengers: 'Passengers are missing',
          time: 'Time is missing',
          start_address: 'Start address is missing',
          end_address: 'End address is missing' }.each do |field, description|
        context field.to_s do
          let(:params) { super().except field }

          it { expect { subject }.to raise_error ArgumentError, description }
        end
      end
    end
  end
end
