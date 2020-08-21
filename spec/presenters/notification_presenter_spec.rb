# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationPresenter do
  let(:notification) { build(:notification) }

  describe 'MODEL_ATTRIBUTES constant' do
    subject { described_class::MODEL_ATTRIBUTES }
    it { is_expected.to eq %i[id created_at updated_at title body status notification_type subject] }
  end

  describe '#notification_page_context' do
    subject { described_class.new(notification).notification_page_context }

    it { is_expected.to be_instance_of Hash }

    let(:response) do
      {
        id: notification.id,
        created_at: notification.created_at,
        updated_at: notification.updated_at,
        title: notification.title,
        body: notification.body,
        status: notification.status,
        notification_type: notification.notification_type,
        subject: notification.subject
      }
    end

    it 'returns Hash with expected fields' do
      expect(subject).to eq(response)
    end
  end

  describe 'delegates' do
    subject { described_class.new(notification) }

    NotificationPresenter::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
