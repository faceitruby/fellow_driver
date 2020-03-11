# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Registration::UpdateService do
  describe '#call' do
    let(:user) { create(:user, :create, phone: nil) }
    let(:service) { Users::Registration::UpdateService.new(user_params) }
    subject { service.call }

    before { allow(service).to receive(:receive_user).and_return(user) }

    context 'with all fields provided' do
      let(:user_params) { attributes_for(:user, email: user.email) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'changes user' do
        last_user = User.last
        expect do
          service.call
          last_user.reload
        end.to change(last_user, :first_name)
          .and change(last_user, :last_name)
          .and change(last_user, :address)
          .and change(last_user, :avatar_attached?)
      end
      it_behaves_like 'provided fields'
    end

    context 'update with missing fields' do
      let(:user_params) { attributes_for(:user, email: user.email, first_name: nil) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'doesn\'t change user' do
        last_user = User.last
        expect do
          service.call
          last_user.reload
        end.to not_change(last_user, :first_name)
          .and not_change(last_user, :last_name)
          .and not_change(last_user, :address)
          .and not_change(last_user, :avatar_attached?)
      end
      it_behaves_like 'missing fields'
    end
  end
end
