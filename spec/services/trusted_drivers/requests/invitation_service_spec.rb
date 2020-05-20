# frozen_string_literal: true

require 'rails_helper'

# OpenStruct returned from services
RSpec.shared_examples 'trusted_driver_request invite' do
  it { expect(subject.class).to eq(OpenStruct) }
  it { expect(subject.errors).to eq(nil) }
  it { expect(subject.success?).to be true }
  it { expect { subject }.to change(User, :count).by(1) }
end

RSpec.describe TrustedDrivers::Requests::InvitationService do
  subject { described_class.perform(params) }

  describe '#call' do
    context 'when success invited' do
      context 'by email' do
        let(:email) { Faker::Internet.email }
        let(:params) { { email: email } }

        it_behaves_like 'trusted_driver_request invite'
      end

      context 'by phone' do
        let(:phone) { Faker::Base.numerify('+#####-###-####') }
        let(:params) { { phone: phone } }

        it_behaves_like 'trusted_driver_request invite'
      end
    end
  end
end
