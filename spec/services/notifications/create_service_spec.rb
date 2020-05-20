# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::CreateService do
  let(:params) do
    {
      title: Faker::Lorem.sentence(word_count: 1),
      body: Faker::Lorem.sentence(word_count: 1),
      notification_type: Faker::Lorem.sentence(word_count: 1),
      user: create(:user)
    }
  end

  subject { described_class.perform(params) }

  describe '#call' do
    it { expect { subject }.to change(Notification, :count).by(1) }
  end
end
