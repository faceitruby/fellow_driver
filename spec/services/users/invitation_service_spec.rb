# frozen_string_literal: true

require 'rails_helper'

# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.shared_examples 'correct result' do
  it 'returns Hash object' do
    expect(subject).to be_instance_of User
  end
  it 'invited user has invitation token' do
    expect(subject.raw_invitation_token).to be_instance_of(String) && be_present
  end
  it 'creates User' do
    expect { subject }.to change(User, :count).by(1)
  end
  it 'new user is invited by current user' do
    expect(subject[:invited_by_id]).to eq(current_user.id)
  end
  it 'new user has family_id from current user' do
    expect(subject[:family_id]).to eq(current_user.family.id)
  end
  it { expect { subject }.to_not raise_error }
  it do
    expect(Resque).to receive(:enqueue).with(InvitePhoneJob, params[:phone], instance_of(String)).once
    subject
  end
end

RSpec.shared_examples 'wrong result' do
  it { expect(subject_ignore_exceptions).to be nil }
  it 'doesnt create User' do
    expect { subject_ignore_exceptions }.to_not change(User, :count)
  end
  it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
  it do
    expect(Resque).to receive(:enqueue).with(InvitePhoneJob, params[:phone], instance_of(String)).exactly(0).times
    subject_ignore_exceptions
  end
  it do
    expect(FamilyMembers::EmailMessenger).to receive(:perform).with(instance_of(Hash)).exactly(0).times
    subject_ignore_exceptions
  end
end

RSpec.describe Users::InvitationService do
  let!(:current_user) { create(:user) }
  let(:params) do
    attributes_for(:user, :random_member).slice(:first_name, :last_name, :phone, :email, :member_type)
  end
  let(:invite_params) { ActionController::Parameters.new(params) }

  before do
    allow(Twilio::TwilioTextMessenger).to receive(:perform)
    allow(FamilyMembers::EmailMessenger).to receive(:perform)
  end

  subject { described_class.perform(invite_params.merge(current_user: current_user)) }

  describe '#call' do
    context 'with correct params' do
      it_behaves_like 'correct result'

      it do
        expect(FamilyMembers::EmailMessenger).to receive(:perform).with(instance_of(Hash)).once
        subject
      end
    end

    %i[phone member_type].each do |param|
      context "with missing #{param}" do
        let(:invite_params) { super().except(:email, param) }

        it_behaves_like 'wrong result'
      end
    end

    %i[first_name last_name].each do |param|
      context "with missing #{param}" do
        let(:invite_params) { super().except(param) }

        it_behaves_like 'correct result'
        it do
          expect(FamilyMembers::EmailMessenger).to receive(:perform).with(instance_of(Hash)).once
          subject
        end
      end
    end

    context 'when missing email' do
      let(:invite_params) { super().except(:email) }

      it_behaves_like 'correct result'
      it do
        expect(FamilyMembers::EmailMessenger).to receive(:perform).with(instance_of(Hash)).exactly(0).times
        subject
      end
    end

    %i[phone email].each do |param|
      context "with dublicated #{param}" do
        let!(:user) { create(:user, param => invite_params[param]) }

        it_behaves_like 'wrong result'
      end
    end
  end
end
