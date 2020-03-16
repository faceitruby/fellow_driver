# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Registration::UpdateService do
  describe '#call' do
    let(:user) { create(:user, :create, phone: nil) }
    subject { described_class.new(user_params).call }

    before { allow_any_instance_of(described_class).to receive(:user).and_return(user) }

    context 'with all fields provided' do
      let(:user_params) { attributes_for(:user, email: user.email) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'changes user' do
        expect do
          subject
          user.reload # ensure attributes changes in DB, not only in user variable
        end.to change(user, :first_name)
          .and change(user, :last_name)
          .and change(user, :address)
          .and change(user, :avatar_attached?)
      end
      it_behaves_like 'provided fields'
    end

    context 'update with missing fields' do
      let(:user_params) { attributes_for(:user, email: user.email, first_name: nil) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'doesn\'t change user' do
        expect do
          subject
          user.reload # we need to reload because attributes changes in user variable (but doesn`t change in DB)
        end.to not_change(user, :first_name)
          .and not_change(user, :last_name)
          .and not_change(user, :address)
          .and not_change(user, :avatar_attached?)
      end
      it_behaves_like 'missing fields'
    end
  end
end
