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
  let(:my_params) { invite_params.merge(current_user: user) }

  context ' ' do
    subject { Users::InvitationService.perform(ActionController::Parameters.new(my_params)) }

    before { allow(Twilio::TwilioTextMessenger).to receive(:perform) }

    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.data[:user].class).to eq(Hash) }
    it { expect(subject.errors).to eq(nil) }
    it { expect(subject.success?).to be true }
    it { expect { subject }.to change(User, :count).by(2) }
  end


end
