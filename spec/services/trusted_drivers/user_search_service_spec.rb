# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrustedDrivers::UserSearchService do
  let(:search_params) { { email: nil, phone: nil, uid: nil } }
  subject { described_class.perform(search_params) }

  context 'when user exist' do
    let(:searched_user) { create(:user, :create, :facebook) }

    context 'by email' do
      let(:search_params) { super().merge(email: searched_user.email) }

      it { is_expected.to be_instance_of User }
      it { expect(subject.email).to eq search_params[:email] }
    end

    context 'by phone' do
      let(:search_params) { super().merge(phone: searched_user.phone) }

      it { is_expected.to be_instance_of User }
      it { expect(subject.phone).to eq search_params[:phone] }
    end

    context 'by uid' do
      let(:search_params) { super().merge(uid: searched_user.uid) }

      it { is_expected.to be_instance_of User }
      it { expect(subject.uid).to eq search_params[:uid] }
    end
  end

  context 'when user not exist' do
    it { is_expected.to be nil }
  end
end
