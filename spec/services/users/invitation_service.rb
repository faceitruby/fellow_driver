# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationService do
  let(:user) { create(:user) }
  let(:invite_params) do
    {
      "first_name": Faker::Name.first_name,
      "last_name": Faker::Name.last_name,
      "phone": Faker::Base.numerify('###-###-####'),
      "email": Faker::Internet.email,
      "member_type": Family.member_types.keys.sample,
      "avatar": Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']),
      "address": Faker::Address.full_address
    }
  end
  let(:params) { invite_params.merge(current_user: user) }

  context 'when current user invites new user' do
    context 'with correct params' do
      subject { Users::InvitationService.perform(
          ActionController::Parameters.new(params)
      ) }

      before { allow(Twilio::TwilioTextMessenger).to receive(:perform) }

      it 'returns OpenStruct object' do
        expect(subject.class).to eq(OpenStruct)
      end
      it 'returns a hash with new user' do
        expect(subject.data[:user].class).to eq(Hash)
      end
      it 'has no errors' do
        expect(subject.errors).to eq(nil)
      end
      it 'returns success' do
        expect(subject.success?).to be true
      end
      it 'changes Users and Families counter' do
        expect { subject }.to change(User, :count).by(2) &&
                              change(Family, :count).by(1)
      end
      it 'new user is invited by current user' do
        expect(subject.data[:user][:invited_by_id]).to eq(params[:current_user][:id])
      end
      it 'new user has own family' do
        expect(subject.data[:user][:family_id]).to eq(Family.last.id)
      end
      it 'family has new user and owner' do
        subject
        expect(Family.last.user_id).to eq(subject.data[:user][:id])
        expect(Family.last.owner).to eq(params[:current_user][:id])
      end
    end

    context 'with incorrect params' do
      subject { Users::InvitationService.perform(
          ActionController::Parameters.new(params.merge('phone': nil))
      ) }

      it 'returns OpenStruct object' do
        expect(subject.class).to eq(OpenStruct)
      end
      it 'returns a hash without new user' do
        expect(subject.data).to eq(nil)
      end
      it 'has errors' do
        expect(subject.errors).not_to eq(nil)
      end
      it 'returns not success' do
        expect(subject.success?).to be false
      end
      it 'dont changes Users and Families counter' do
        expect { subject }.to change(User, :count).by(1) &&
                              change(Family, :count).by(0)
      end
    end
  end
end
