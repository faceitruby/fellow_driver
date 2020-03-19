# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'user search' do
  subject { TrustedDrivers::UserSearchService.perform(search_params) }

  it { expect(subject.class).to eq(OpenStruct) }
  it { expect(subject.errors).to eq(error) }
  it { expect(subject.success?).to be success }
  it { expect(subject.data).to eq(data) }
end

RSpec.describe TrustedDrivers::UserSearchService do
  context 'when user exist' do
    let(:searched_user) { create(:user, :facebook) }
    let(:error) { nil }
    let(:success) { true }
    let(:data) { { user: searched_user } }

    context 'by email' do
      let(:search_params) { { email: searched_user.email } }

      it_behaves_like 'user search'
    end

    context 'by phone' do
      let(:search_params) { { email: searched_user.email } }

      it_behaves_like 'user search'
    end

    context 'by uid' do
      let(:search_params) { { uid: searched_user.uid } }

      it_behaves_like 'user search'
    end
  end

  context 'when user not exist' do
    let(:error) { nil }
    let(:success) { false }
    let(:data) { nil }

    context 'by email' do
      let(:search_params) { { email: Faker::Internet.email } }

      it_behaves_like 'user search'
    end

    context 'by phone' do
      let(:search_params) { { phone: Faker::PhoneNumber.phone_number_with_country_code } }

      it_behaves_like 'user search'
    end

    context 'by uid' do
      let(:search_params) { { uid: Faker::Number.number(digits: 15) } }

      it_behaves_like 'user search'
    end
  end
end
