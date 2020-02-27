# frozen_string_literal: true

require 'rails_helper'
require 'support/shared/results_shared'

RSpec.describe 'Session service' do
  describe '#call' do
    context 'when authenticated user provided' do
      let(:user) { build(:user, :create_params_only, email: 'user@example.com', phone: nil) }
      subject { Users::SessionService.new(user).call }

      it { is_expected.to be_instance_of OpenStruct }
      it_behaves_like 'when fields present'
    end
    context 'when authenticated user is missing' do
      subject { Users::SessionService.new.call }

      it { is_expected.to be_instance_of OpenStruct }
      it_behaves_like 'when fields missed'
    end
  end
end
