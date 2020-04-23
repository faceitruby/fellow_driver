# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamilyPresenter do
  let(:family) { create(:family) }

  describe 'constants' do
    describe 'MODEL_ATTRIBUTES' do
      let(:attributes_list) { %i[id created_at updated_at] }

      subject { described_class::MODEL_ATTRIBUTES }

      it { is_expected.to eq attributes_list }
    end
  end

  describe '#page_content' do
    let(:expected_presenter) { family.attributes.symbolize_keys.merge(members: family.users) }

    subject { described_class.new(family).family_page_context }

    it { is_expected.to be_instance_of Hash }
    it { is_expected.to eq expected_presenter }
  end

  describe 'delegates' do
    subject { described_class.new(family) }

    described_class::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
