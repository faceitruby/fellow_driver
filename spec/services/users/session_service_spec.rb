# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionService do
  describe '#call' do
    context 'when authenticated user' do
      context 'is provided' do
        let(:user) { build(:user, :create, email: 'user@example.com', phone: nil) }
        let(:params) { { user: user } }
        subject { described_class.new(params).call }

        it { expect { subject }.to_not raise_error }
        it { is_expected.to be_instance_of String }
      end

      context 'is missed' do
        subject { described_class.new.call }

        it { expect { subject }.to raise_error ActiveRecord::RecordNotFound }
      end
    end
  end
end
