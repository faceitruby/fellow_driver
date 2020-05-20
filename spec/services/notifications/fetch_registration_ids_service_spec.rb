# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::FetchRegistrationIdsService do
  let(:device) { create(:device) }
  let(:params) { { user: device.user } }

  subject { described_class.perform(params) }

  describe '#call' do
    context 'success' do
      context 'user have stored device' do
        it { expect(subject).to eq([device.registration_ids]) }
      end

      context 'user not have stored device' do
        let(:params) { { user: create(:user) } }

        it { expect(subject).to eq([]) }
      end
    end

    context 'invalid params' do
      let(:params) { { user: nil } }
      let(:error_message) { 'No registered ids for user' }

      it { expect { subject }.to raise_error(ArgumentError).with_message(error_message) }
    end
  end
end
