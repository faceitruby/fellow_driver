# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::Messages::FetchSingleTemplateService do
  include ActiveSupport::Testing::TimeHelpers

  let(:family) { build_stubbed :family }
  let(:passengers) do
    %w[son daughter mother father].map { |type| build_stubbed :user, member_type: type, family_id: family.id }
  end
  let(:template_text) do
    'I’m looking for some help to get relationship name from start_address date. Any chance you could help?'
  end
  let(:ride_template) { build_stubbed :ride_template, text: template_text }
  let(:ride) do
    build_stubbed :ride, requestor: passengers.first,
                         message_attributes: { ride_template_id: ride_template.id }
  end
  let(:params) { { id: ride.id } }
  let(:relation_members) do
    [
      { relation: 'son', name: passengers[0].first_name },
      { relation: 'daughter', name: passengers[1].first_name },
      { relation: 'mother', name: passengers[2].first_name },
      { relation: 'father', name: passengers[3].first_name }
    ]
  end
  let(:expected_text) do
    "I’m looking for some help to get my kids #{passengers[0].first_name} and #{passengers[1].first_name} "\
      "and parents #{passengers[2].first_name} and #{passengers[3].first_name} from #{ride.start_address} "\
      "#{time_str}. Any chance you could help?"
  end

  before do
    travel_to Time.new(2020, 8, 17, 13, 15, 30).in_time_zone
    allow(RideTemplate).to receive(:find).and_return(ride_template)
    allow(Ride).to receive_message_chain(:includes, :find).and_return(ride)
    allow(FamilyMembers::FetchRelationService).to receive(:perform).and_return(relation_members)
  end

  subject { described_class.perform(params) }

  describe '#call' do
    context 'whit correct params' do
      let(:time_str) { 'tomorrow' }

      it { is_expected.to be_instance_of RideTemplate }
      it { expect(subject.text).to eq expected_text }
    end

    context 'with missing id' do
      let(:params) { {} }
      let(:message) { 'Template id is missing' }

      it { expect { subject }.to raise_error ArgumentError, message }
    end

    context 'when ride will be' do
      let(:ride) do
        build_stubbed :ride, requestor: passengers.first, date: date, created_at: Time.current,
                             message_attributes: { ride_template_id: ride_template.id }
      end
      let(:date) { Time.current + time_buffer }
      let(:time_buffer) { 15.minutes }

      context 'today' do
        let(:date) { super() + 1.hour }
        let(:time_str) { 'today' }

        it { expect(subject.text).to eq expected_text }
      end

      context 'tomorrow' do
        let(:date) { super() + 1.day }
        let(:time_str) { 'tomorrow' }

        it { expect(subject.text).to eq expected_text }
      end

      context 'this week on' do
        { Wednesday: 2, Thursday: 3, Friday: 4, Saturday: 5, Sunday: 6 }.each do |day_name, number|
          context day_name.to_s do
            let(:date) { (super() + number.day).to_s }
            let(:time_str) { "on #{day_name}" }

            it { expect(subject.text).to eq expected_text }
          end
        end
      end

      context 'in one week' do
        let(:date) { (super() + 7.days).to_s }
        let(:time_str) { 'on 24 Aug 01:30 PM' }

        it { expect(subject.text).to eq expected_text }
      end
    end

    context 'when ride does not use template' do
      let(:ride) do
        build_stubbed :ride, requestor: passengers.first,
                             message_attributes: { message: Faker::Lorem.sentence }
      end
      let(:message) { 'This ride request doesn\'t use ride_templates' }

      it { expect { subject }.to raise_error ArgumentError, message }
    end
  end
end
