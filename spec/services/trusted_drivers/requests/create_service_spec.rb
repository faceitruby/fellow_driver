# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'trusted_driver_request create' do
  before do
    allow(TrustedDrivers::Messages::PrepareMessageService).to receive(:perform)
      .with(messages_params)
      .and_return(OpenStruct.new(success?: true, data: {}))

    allow(TrustedDrivers::UserSearchService).to receive(:perform)
      .with(user_search_params)
      .and_return(user_search_response)
  end

  it { expect(subject.class).to eq(OpenStruct) }
  it { expect(subject.errors).to eq(error) }
  it { expect(subject.success?).to be success }
  it { expect { subject }.to change(TrustedDriverRequest, :count).by(change_count) }
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

  subject { TrustedDrivers::Requests::CreateService.perform(params) }

  context 'when valid request' do
    let(:change_count) { 1 }
    let(:success) { true }
    let(:error) { nil }

    context 'when user exist' do
      context 'by phone' do
        let(:params) { { phone: receiver.phone, current_user: requestor } }
        let(:user_search_params) { { phone: receiver.phone } }

        let(:user_search_response) do
          OpenStruct.new(success?: true, data: { user: receiver }, errors: nil)
        end

        it_behaves_like 'trusted_driver_request create'
      end

      context 'by email' do
        let(:user_search_params) { { email: receiver.email } }

        let(:user_search_response) do
          OpenStruct.new(success?: true, data: { user: receiver }, errors: nil)
        end

        let(:params) { { email: receiver.email, current_user: requestor } }

        it_behaves_like 'trusted_driver_request create'
      end

      context 'by uid' do
        let(:user_search_params) { { uid: receiver.uid } }

        let(:user_search_response) do
          OpenStruct.new(success?: true, data: { user: receiver }, errors: nil)
        end

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
        let(:user_search_response) { OpenStruct.new(success?: false, data: nil, errors: nil) }

        let(:invite_params) do
          {
            current_user: requestor,
            phone: user_search_params[:phone]
          }
        end

        let(:invite_response) do
          receiver.phone = invite_params[:phone]
          OpenStruct.new(
            success?: true,
            data: {
              invite_token: 'invite.raw_invitation_token',
              user: receiver
            },
            errors: nil
          )
        end

        it_behaves_like 'trusted_driver_request create'
      end

      context 'by email' do
        let(:params) { { email: user_search_params[:email], current_user: requestor } }

        let(:user_search_params) { { email: Faker::Internet.email } }
        let(:user_search_response) do
          OpenStruct.new(success?: false, data: nil, errors: nil)
        end

        let(:invite_params) do
          {
            current_user: requestor,
            email: user_search_params[:email]
          }
        end

        let(:invite_response) do
          receiver.email = invite_params[:email]

          OpenStruct.new(
            success?: true,
            data: {
              invite_token: 'raw_invitation_token',
              user: receiver
            },
            errors: nil
          )
        end

        it_behaves_like 'trusted_driver_request create'
      end
    end
  end

  context 'when invalid request' do
    let(:change_count) { 0 }
    let(:success) { false }
    let(:error) { invite_response.errors }

    context 'by login' do
      let(:invite_response) do
        receiver.phone = invite_params[:phone]
        OpenStruct.new(success?: false, data: nil, errors: { login: ["can't be blank"] })
      end

      let(:user_search_response) { OpenStruct.new(success?: false, data: nil, errors: nil) }

      context 'email' do
        let(:params) { { email: user_search_params[:email], current_user: requestor } }

        let(:user_search_params) { { email: 'wrong' } }

        let(:invite_params) do
          {
            current_user: requestor,
            phone: user_search_params[:email]
          }
        end

        it_behaves_like 'trusted_driver_request create'
      end

      context 'phone' do
        let(:params) { { phone: user_search_params[:phone], current_user: requestor } }

        let(:user_search_params) { { phone: 'wrong' } }

        let(:invite_params) do
          {
            current_user: requestor,
            phone: user_search_params[:phone]
          }
        end

        it_behaves_like 'trusted_driver_request create'
      end
    end

    context 'by uid' do
      context 'when user not exist' do
        before do
          allow(TrustedDrivers::Requests::InvitationService).to receive(:perform)
            .with(invite_params)
            .and_return(invite_response)
        end

        let(:params) { { uid: user_search_params[:uid], current_user: requestor } }

        let(:user_search_params) { { uid: Faker::Number.number(digits: 15) } }

        let(:user_search_response) do
          OpenStruct.new(success?: false, data: nil, errors: nil)
        end

        let(:invite_params) do
          {
            current_user: requestor,
            uid: user_search_params[:uid]
          }
        end

        let(:invite_response) do
          OpenStruct.new(success?: false, data: nil, errors: { login: ["can't be blank"] })
        end

        it_behaves_like 'trusted_driver_request create'
      end
    end
  end
end
