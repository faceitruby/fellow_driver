# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'success invite' do
  it { is_expected.to be_instance_of User }
  it { expect { subject }.to change(User, :count).by(1) }
  it { expect { subject }.to_not raise_error }
end

RSpec.shared_examples 'failed invite' do
  it { expect { subject_ignore_exceptions }.to_not change(User, :count) }
  it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
end

RSpec.describe TrustedDrivers::Requests::InvitationService do
  let!(:current_user) { create(:user, :create) }
  let(:params) do
    {
      current_user: current_user,
      member_type: User.member_types.keys.sample
    }
  end
  subject { described_class.perform(params) }

  describe '#call' do
    context 'when success invited' do
      context 'by email' do
        let(:params) { super().merge(email: Faker::Internet.email) }

        it_behaves_like 'success invite'
      end

      context 'by phone' do
        let(:params) { super().merge(phone: Faker::Base.numerify('+#####-###-####')) }

        it_behaves_like 'success invite'
      end
    end

    context 'when error raised' do
      let(:params) { super().merge(email: Faker::Internet.email) }
      before { allow_any_instance_of(User).to receive(:save).and_raise(ActiveRecord::RecordInvalid) }

      it_behaves_like 'failed invite'
    end
  end
end
