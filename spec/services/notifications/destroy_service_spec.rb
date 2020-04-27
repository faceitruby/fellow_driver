# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::DestroyService do
  describe '#call' do
  let(:params) { { notification: create(:notification) } }
  subject { described_class.perform(params) }
  it { expect { subject }.to change(Notification, :count).by(0) }
  end
end
