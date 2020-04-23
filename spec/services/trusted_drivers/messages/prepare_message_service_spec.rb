# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'prepare_message' do
  it { expect(subject.class).to eq(OpenStruct) }
  it { expect(subject.errors).to eq(nil) }
  it { expect(subject.success?).to be true }
  it { expect(subject.data).to eq(result) }
end

RSpec.describe TrustedDrivers::Messages::PrepareMessageService do
  let(:requestor) { create(:user) }
  let(:receiver) { create(:user, :facebook) }
  let(:params) do
    {
      current_user: requestor,
      user_receiver: user_receiver
    }
  end

  subject { described_class.perform(params) }

  before do
    allow(TrustedDrivers::Messages::SendEmailService).to receive(:perform).and_return(nil)

    allow_any_instance_of(described_class).to receive(:send_phone_message)
      .and_return({ phone_message: 'phone request sended' })
  end

  describe '#call' do
    context 'when receiver have' do
      context 'phone' do
        let(:user_receiver) { build(:user, email: nil) }
        let(:result) { { phone_message: 'phone request sended' } }

        it_behaves_like 'prepare_message'
      end

      context 'email' do
        let(:user_receiver) { build(:user, phone: nil) }
        let(:result) { { email_message: 'email request sended' } }

        it_behaves_like 'prepare_message'
      end

      context 'uid' do
        let(:user_receiver) { build(:user, :facebook, phone: nil, email: nil) }
        let(:result_message) { 'Invite message' }

        before do
          allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
            .with(current_user: requestor, user_receiver: user_receiver)
            .and_return(result_message)
        end

        let(:result) { { facebook_message: { message: result_message, uid: user_receiver.uid } } }

        it_behaves_like 'prepare_message'
      end

      context 'phone and email' do
        let(:user_receiver) { build(:user) }

        let(:result) do
          {
            phone_message: 'phone request sended',
            email_message: 'email request sended'
          }
        end

        it_behaves_like 'prepare_message'
      end

      context 'phone and uid' do
        let(:user_receiver) { build(:user, :facebook, email: nil) }
        let(:result_message) { 'Invite message' }

        before do
          allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
            .with(current_user: requestor, user_receiver: user_receiver)
            .and_return(result_message)
        end

        let(:result) do
          {
            phone_message: 'phone request sended',
            facebook_message: { message: result_message, uid: user_receiver.uid }
          }
        end

        it_behaves_like 'prepare_message'
      end

      context 'email and uid' do
        let(:user_receiver) { build(:user, :facebook, phone: nil) }
        let(:result_message) { 'Invite message' }

        before do
          allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
            .with(current_user: requestor, user_receiver: user_receiver)
            .and_return(result_message)
        end

        let(:result) do
          {
            email_message: 'email request sended',
            facebook_message: { message: result_message, uid: user_receiver.uid }
          }
        end

        it_behaves_like 'prepare_message'
      end

      context 'phone, email and uid' do
        let(:user_receiver) { receiver }
        let(:result_message) { 'Invite message' }

        before do
          allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
            .with(current_user: requestor, user_receiver: user_receiver)
            .and_return(result_message)
        end

        let(:result) do
          {
            phone_message: 'phone request sended',
            email_message: 'email request sended',
            facebook_message: { message: result_message, uid: receiver.uid }
          }
        end

        it_behaves_like 'prepare_message'
      end
    end
  end
end
