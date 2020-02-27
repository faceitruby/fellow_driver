# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPresenter do
  describe 'MODEL_ATTRIBUTES constant' do
    it 'contains all model fields' do
      expect(UserPresenter::MODEL_ATTRIBUTES).to eq User.attribute_names.map(&:to_sym)
    end
  end

  describe '#page_content' do
    let(:user) { build(:user) }
    subject { described_class.new(user).page_context }

    it { is_expected.to be_instance_of Hash }
  end

  describe 'delegates' do
    let(:user) { build(:user) }
    subject { described_class.new(user) }

    UserPresenter::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
