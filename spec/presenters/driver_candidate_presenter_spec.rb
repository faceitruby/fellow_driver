# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DriverCandidatePresenter do
  let(:driver_candidate) { create(:driver_candidate) }

  describe 'constants' do
    describe 'MODEL_ATTRIBUTES' do
      let(:attributes_list) { %i[id updated_at created_at driver_id ride_id second_connection status] }

      subject { described_class::MODEL_ATTRIBUTES }

      it { is_expected.to eq attributes_list }
    end
  end

  describe '#page_content' do
    let(:expected_presenter) { driver_candidate.attributes.symbolize_keys }

    subject { described_class.new(driver_candidate).page_context }

    it { is_expected.to be_instance_of Hash }
    it { is_expected.to eq expected_presenter }
  end

  describe 'delegates' do
    subject { described_class.new(driver_candidate) }

    described_class::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
