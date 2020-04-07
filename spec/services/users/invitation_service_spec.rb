# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::InvitationService do
  let!(:current_user) { create(:user) }
  let(:invite_params) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      phone: phone,
      email: Faker::Internet.email,
      member_type: User.member_types.keys.sample,
      avatar: Rack::Test::UploadedFile.new(ENV['LOCAL_IMAGE_PATH']),
      address: Faker::Address.full_address
    }
  end

  before do
    allow(Twilio::TwilioTextMessenger).to receive(:perform)
  end
  subject { Users::InvitationService.perform(
      invite_params.merge(current_user: current_user)) }

  context 'when current user invites new user' do
    context 'with correct params' do
      let(:phone) { Faker::Base.numerify('###-###-####') }

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
      it 'changes Users counter' do
        expect { subject }.to change(User, :count).by(1)
      end
      it 'new user is invited by current user' do
        expect(subject.data[:user][:invited_by_id]).to eq(current_user.id)
      end
    end

    context 'with incorrect params' do
      let(:phone) { nil }

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
      it 'doesnt changes Users ' do
        expect { subject }.to_not change(User, :count)
      end
    end
  end
end
