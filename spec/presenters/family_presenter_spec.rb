# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamilyPresenter do
  let(:user) { create(:user) }

  describe 'MODEL_ATTRIBUTES constant' do
    it 'contains all model fields' do
      expect(described_class::MODEL_ATTRIBUTES).to eq Family.attribute_names.map(&:to_sym)
    end
  end

  describe '#page_content' do
    let(:expected_presenter) { user.family.attributes.symbolize_keys.merge(members: user.family.users) }
    subject { described_class.new(user.family).family_page_context }

    it { is_expected.to be_instance_of Hash }
    it { is_expected.to eq expected_presenter }
  end

  describe 'delegates' do
    subject { described_class.new(user) }

    described_class::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
