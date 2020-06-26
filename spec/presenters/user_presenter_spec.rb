# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPresenter do
  describe 'MODEL_ATTRIBUTES constant' do
    it 'contains all model fields' do
      expect(UserPresenter::MODEL_ATTRIBUTES.sort).to eq User.attribute_names.map(&:to_sym).push(:avatar).sort
    end
  end

  describe '#page_content' do
    let(:user) { create(:user) }
    let(:avatar) { Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) }
    subject { described_class.new(user).page_context }

    context 'with all fields present' do
      it { is_expected.to be_instance_of Hash }
      it { is_expected.to eq user.attributes.symbolize_keys.merge(avatar: avatar) }
    end

    context 'with avatar is missing' do
      let(:user) { build(:user, avatar: nil) }

      it { is_expected.to be_instance_of Hash }
      it { is_expected.to eq user.attributes.symbolize_keys }
    end
  end

  describe 'delegates' do
    let(:user) { build(:user) }
    subject { described_class.new(user) }

    UserPresenter::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
