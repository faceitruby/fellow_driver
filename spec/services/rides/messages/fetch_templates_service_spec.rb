# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::Messages::FetchTemplatesService do
  include ActiveSupport::Testing::TimeHelpers
  let(:relation_type) { described_class::RELATION_GROUPS }
  let(:address) { Faker::Address.city }
  let(:time_buffer) { 15.minutes }
  let(:time) { Time.current + time_buffer }
  let(:names) { Array.new(4) { Faker::Name.name } }
  let(:family) { build_stubbed :family }
  let(:passengers) do
    %w[son daughter mother father].map { |type| build :user, member_type: type, family_id: family.id }
  end
  let(:relation_members) do
    [
      { relation: 'son', name: passengers[0].first_name },
      { relation: 'daughter', name: passengers[1].first_name },
      { relation: 'mother', name: passengers[2].first_name },
      { relation: 'father', name: passengers[3].first_name }
    ]
  end
  let(:request_params) do
    {
      id: RideTemplate.first.id,
      time: time,
      start_address: address,
      end_address: address,
      passengers: passengers.pluck(:id)
    }
  end

  subject { described_class.perform(request_params) }

  before(:all) { Rails.application.load_seed }

  before { allow(FamilyMembers::FetchRelationService).to receive(:perform).and_return relation_members }

  describe 'constants' do
    describe 'RELATION_GROUPS' do
      subject { described_class::RELATION_GROUPS }

      it { is_expected.to eq({ kids: %w[son daughter], parents: %w[mother father] }) }
    end
  end

  describe '#call' do
    let(:request_params) { super().except :id }
    let(:expected_response) do
      ["I’m looking for some help to get my kids #{passengers[0].first_name} and #{passengers[1].first_name} and "\
         "parents #{passengers[2].first_name} and #{passengers[3].first_name} from #{address} today. Any chance "\
         'you could help?',
       "I need help picking up my kids #{passengers[0].first_name} and #{passengers[1].first_name} and parents "\
         "#{passengers[2].first_name} and #{passengers[3].first_name} from #{request_params[:start_address]} "\
         'today. Can you help me out?',
       "I need someone to help drive my kids #{passengers[0].first_name} and #{passengers[1].first_name} and "\
         "parents #{passengers[2].first_name} and #{passengers[3].first_name} to #{request_params[:end_address]} "\
         'on today. Are you nearby by any chance?',
       "Could you do me a favor and pickup my kids #{passengers[0].first_name} and #{passengers[1].first_name} "\
         "and parents #{passengers[2].first_name} and #{passengers[3].first_name} from " \
         "#{request_params[:start_address]} today"]
    end
    let(:time) { super().to_s }

    it { expect(subject.pluck(:text)).to eq expected_response }
    it { expect(subject.size).to eq RideTemplate.count }

    { passengers: 'Passengers are missing', time: 'Time is missing', start_address: 'Start address is missing',
      end_address: 'End address is missing' }.each do |field, description|
      context "with empty #{field}" do
        let(:request_params) { super().except field }
        let(:time) { super().to_s }

        it { expect { subject }.to raise_error ArgumentError, description }
      end
    end
  end
end
