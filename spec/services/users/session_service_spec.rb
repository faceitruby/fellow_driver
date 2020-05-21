# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionService do
  describe '#call' do
    context 'when authenticated user' do
      context 'is provided' do
        let(:user) { build(:user, :create, email: 'user@example.com', phone: nil) }
        let(:params) { { user: user } }
        subject { described_class.new(params).call }

        it { expect { subject }.to avoid_raising_error }
        it('returns string') { is_expected.to be_instance_of String }
      end

      context 'is missed' do
        subject { described_class.new.call }

        it { expect { subject }.to raise_error ActiveRecord::RecordNotFound }
        it('returns nil') { expect(subject_ignore_exceptions).to be nil }
      end
    end
  end
end
