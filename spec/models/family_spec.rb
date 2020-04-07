# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Family, type: :model do
  let(:user) { create(:user) }

  context 'assotiation' do
    it { is_expected.to have_many(:users) }
  end

  context 'creating' do
    it 'should increase Family count in DB by 1' do
      expect{ user }.to change{ Family.count }.by(1)
    end
  end
end
