# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitePresenter do
  describe 'MODEL_ATTRIBUTES constant' do
    it 'has all model fields' do
      expect(described_class::MODEL_ATTRIBUTES).to eq [:id,
                                                       :first_name,
                                                       :last_name,
                                                       :phone,
                                                       :email,
                                                       :invited_by_id,
                                                       :family_id]
    end

    describe 'invite_page_context' do
      let(:user) { build(:user) }

      subject { described_class.new(user).invite_page_context }

      it { is_expected.to be_instance_of Hash }
    end

    describe 'delegates' do
      let(:user) { build(:user) }
      subject { described_class.new(user) }

      InvitePresenter::MODEL_ATTRIBUTES.each do |method|
        it { is_expected.to delegate_method(method).to :record }
      end
    end
  end
end
