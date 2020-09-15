# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RideTemplatePresenter do
  let(:template) { create(:ride_template) }

  describe 'constants' do
    describe 'MODEL_ATTRIBUTES' do
      let(:fields) { %i[id text] }

      it { expect(described_class::MODEL_ATTRIBUTES).to eq fields }
    end
  end

  describe 'methods' do
    describe '#page_context' do
      let(:response) do
        {
          id: template.id,
          text: template.text
        }
      end

      subject { described_class.new(template).page_context }

      it { is_expected.to eq response }
      it { is_expected.to be_instance_of Hash }
    end
  end

  describe 'delegates' do
    subject { described_class.new(template) }

    described_class::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to(:record) }
    end
  end
end
