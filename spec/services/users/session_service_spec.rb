# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionService do
  describe '#call' do
    context 'when authenticated user' do
      context 'is provided' do
        let(:user) { build(:user, :create, email: 'user@example.com', phone: nil) }
        let(:params) { { user: user } }
        subject { described_class.new(params).call }

        it { is_expected.to be_instance_of OpenStruct }
        it_behaves_like 'provided fields'
      end

      context 'is missed' do
        subject { described_class.new.call }

        it { is_expected.to be_instance_of OpenStruct }
        it_behaves_like 'missing fields'
      end
    end
  end
end
