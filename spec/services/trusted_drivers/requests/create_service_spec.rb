# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'trusted_driver_request create' do
  before do
    allow(TrustedDrivers::Messages::PrepareMessageService).to receive(:perform)
      .with(messages_params)
      .and_return({ email_message: 'email request sent' })

    allow(TrustedDrivers::UserSearchService).to receive(:perform)
      .with(user_search_params)
      .and_return(user_search_response)
  end

  it { expect(subject).to be_instance_of Hash }
  it { expect { subject }.to change(TrustedDriverRequest, :count).by(1) }
end

RSpec.describe TrustedDrivers::Requests::CreateService do
  let(:requestor) { create(:user) }
  let(:receiver) { create(:user, :facebook) }

  let(:messages_params) do
    {
      user_receiver: receiver,
      current_user: requestor
    }
  end

  subject { described_class.perform(params) }

  context 'when valid request' do
    context 'when user exist' do
      context 'by phone' do
        let(:params) { { phone: receiver.phone, current_user: requestor } }
        let(:user_search_params) { { phone: receiver.phone } }
        let(:user_search_response) { receiver }

        it_behaves_like 'trusted_driver_request create'
      end

      context 'by email' do
        let(:user_search_params) { { email: receiver.email } }
        let(:user_search_response) { receiver }
        let(:params) { { email: receiver.email, current_user: requestor } }

        it_behaves_like 'trusted_driver_request create'
      end

      context 'by uid' do
        let(:user_search_params) { { uid: receiver.uid } }
        let(:user_search_response) { receiver }
        let(:params) { { uid: receiver.uid, current_user: requestor } }

        it_behaves_like 'trusted_driver_request create'
      end
    end

    context 'when user not exist' do
      before do
        allow(TrustedDrivers::Requests::InvitationService).to receive(:perform)
          .with(invite_params)
          .and_return(invite_response)
      end

      context 'by phone' do
        let(:params) { { phone: user_search_params[:phone], current_user: requestor } }
        let(:user_search_params) { { phone: Faker::Base.numerify('+#####-###-####') } }
        let(:user_search_response) { nil }
        let(:invite_params) do
          {
            current_user: requestor,
            phone: user_search_params[:phone]
          }
        end
        let(:invite_response) do
          receiver.phone = invite_params[:phone]
          receiver
        end

        it_behaves_like 'trusted_driver_request create'
      end

      context 'by uid' do
        let(:params) { { uid: user_search_params[:uid], current_user: requestor } }
        let(:user_search_params) { { uid: Faker::Number.number(digits: 15) } }
        let(:user_search_response) { nil }
        let(:invite_params) do
          {
            current_user: requestor,
            uid: user_search_params[:uid]
          }
        end
        let(:invite_response) do
          receiver.uid = invite_params[:uid]
          receiver
        end

        it_behaves_like 'trusted_driver_request create'
      end

      context 'by email' do
        let(:params) { { email: user_search_params[:email], current_user: requestor } }
        let(:user_search_params) { { email: Faker::Internet.email } }
        let(:user_search_response) { nil }

        let(:invite_params) do
          {
            current_user: requestor,
            email: user_search_params[:email]
          }
        end

        let(:invite_response) do
          receiver.email = invite_params[:email]
          receiver
        end

        it_behaves_like 'trusted_driver_request create'
      end
    end
  end

  context 'when invalid request' do
    context 'when error raised by invitation' do
      let(:user_search_response) { nil }
      let(:params) { { email: user_search_params[:email], current_user: requestor } }
      let(:user_search_params) { { email: 'wrong' } }

      before do
        allow(TrustedDrivers::Requests::InvitationService).to receive(:perform)
          .and_raise(ActiveRecord::RecordNotUnique)
      end

      it { expect { subject }.to raise_error ActiveRecord::RecordNotUnique }
      it { expect { subject_ignore_exceptions }.to_not change(TrustedDriverRequest, :count) }
    end

    context 'when trusted_driver_request already exists' do
      let!(:request) { create(:trusted_driver_request, receiver: receiver, requestor: requestor) }
      let(:user_search_params) { { email: 'wrong' } }
      let(:user_search_response) { nil }
      let(:params) { { email: receiver.email, current_user: requestor } }

      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
      it { expect { subject_ignore_exceptions }.to_not change(TrustedDriverRequest, :count) }
    end
  end
end
