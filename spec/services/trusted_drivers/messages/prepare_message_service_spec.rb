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

    before do
      allow(TrustedDrivers::Messages::SendEmailService).to receive(:perform)
      .and_return(nil)

      allow_any_instance_of(TrustedDrivers::Messages::PrepareMessageService).to receive(:send_phone_message)
      .and_return({ phone_message: 'phone request sended' })
    end

  context 'when receiver have' do
    context 'phone' do
      let(:receiver_phone) do
        receiver[:email] = nil
        receiver[:uid] = nil
        receiver
      end

      let(:result) { { phone_message: 'phone request sended' } }

      subject { TrustedDrivers::Messages::PrepareMessageService.perform(current_user: requestor,user_receiver: receiver_phone) }

      it_behaves_like 'prepare_message'
    end

    context 'email' do
      let(:receiver_email) do
        receiver[:phone] = nil
        receiver[:uid] = nil
        receiver
      end

      let(:result) { { email_message: 'email request sended' } }

      subject { TrustedDrivers::Messages::PrepareMessageService.perform(current_user: requestor,user_receiver: receiver_email) }

      it_behaves_like 'prepare_message'
    end

    context 'uid' do
      let(:receiver_uid) do
        receiver[:phone] = nil
        receiver[:email] = nil
        receiver
      end

      let(:result_message) do
        'Invite message'
      end

      before do
        allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
        .with(current_user: requestor, user_receiver: receiver_uid)
        .and_return(result_message)
      end

      let(:result) { { facebook_message: { message: result_message, uid: receiver_uid.uid } } }

      subject { TrustedDrivers::Messages::PrepareMessageService.perform(current_user: requestor,user_receiver: receiver_uid) }

      it_behaves_like 'prepare_message'
    end

    context 'phone and email' do
      let(:receiver_phone_email) do
        receiver[:uid] = nil
        receiver
      end

      let(:result) do
        {
          phone_message: 'phone request sended',
          email_message: 'email request sended'
        }
      end

      subject { TrustedDrivers::Messages::PrepareMessageService.perform(current_user: requestor,user_receiver: receiver_phone_email) }

      it_behaves_like 'prepare_message'
    end

    context 'phone and uid' do
      let(:receiver_phone_uid) do
        receiver[:email] = nil
        receiver
      end

      let(:result_message) do
        'Invite message'
      end

      before do
        allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
        .with(current_user: requestor, user_receiver: receiver_phone_uid)
        .and_return(result_message)
      end

      let(:result) do
        {
          phone_message: 'phone request sended',
          facebook_message: { message: result_message, uid: receiver_phone_uid.uid }
        }
      end

      subject { TrustedDrivers::Messages::PrepareMessageService.perform(current_user: requestor,user_receiver: receiver_phone_uid) }

      it_behaves_like 'prepare_message'
    end

    context 'email and uid' do
      let(:receiver_email_uid) do
        receiver[:phone] = nil
        receiver
      end

      let(:result_message) do
        'Invite message'
      end

      before do
        allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
        .with(current_user: requestor, user_receiver: receiver_email_uid)
        .and_return(result_message)
      end

      let(:result) do
        {
          email_message: 'email request sended',
          facebook_message: { message: result_message, uid: receiver_email_uid.uid }
        }
      end

      subject { TrustedDrivers::Messages::PrepareMessageService.perform(current_user: requestor,user_receiver: receiver_email_uid) }

      it_behaves_like 'prepare_message'
    end


    context 'phone, email and uid' do
      let(:result_message) do
        'Invite message'
      end

      before do
        allow(TrustedDrivers::Messages::CreateService).to receive(:perform)
        .with(current_user: requestor, user_receiver: receiver)
        .and_return(result_message)
      end

      let(:result) do
        {
          phone_message: 'phone request sended',
          email_message: 'email request sended',
          facebook_message: { message: result_message, uid: receiver.uid }
        }
      end

      subject { TrustedDrivers::Messages::PrepareMessageService.perform(current_user: requestor,user_receiver: receiver) }

      it_behaves_like 'prepare_message'
    end
  end
end
