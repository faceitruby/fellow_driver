# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamilyPresenter do
  let!(:current_user) { create(:user) }
  let!(:user) { create(:user) }
  let(:family) { create(:family) }
  let(:response) do
    {
        user_id: family.user_id,
        member_type: family.member_type,
        name: user.first_name + ' ' + user.last_name,
        phone: user.phone,
        email: user.email,
        address: user.address
    }
  end

  describe 'MODEL_ATTRIBUTES constant' do
    subject { described_class::MODEL_ATTRIBUTES }
    it { is_expected.to eq %i[user_id member_type] }
  end

  describe 'family_page_context' do
    subject { described_class::new(family).family_page_context }

    it { is_expected.to be_instance_of Hash }
    it { expect(subject).to eq(response) }
  end
end
