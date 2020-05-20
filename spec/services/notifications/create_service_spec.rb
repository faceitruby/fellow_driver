# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::CreateService do
  let(:title) { Faker::Lorem.sentence(word_count: 1) }
  let(:body) { Faker::Lorem.sentence(word_count: 1) }
  let(:notification_type) { Faker::Lorem.sentence(word_count: 1) }
  let(:notification_subject) { Faker::Lorem.sentence(word_count: 1) }
  let(:params) do
    {
      title: title,
      body: body,
      notification_type: notification_type,
      subject: notification_subject
    }
  end

  subject { described_class.perform(params) }

  describe '#call' do
    context 'success' do
      it { expect { subject }.to change(Notification, :count).by(1) }
    end

    context 'no success' do
      %i[title body notification_type notification_subject].each do |field|
        let(field) { nil }
        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end
end
