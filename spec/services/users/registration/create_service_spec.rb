# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Registration::CreateService do
  describe '#call' do
    subject { described_class.new(user_params).call }

    context 'with email provided' do
      context 'and has not been taken' do
        let(:user_params) { attributes_for(:user, :create, phone: nil) }

        it { is_expected.to be_instance_of OpenStruct }
        it 'creates user' do
          expect { subject }.to change(User, :count).by(1)
        end
        it_behaves_like 'provided fields'
      end

      context 'and has been taken' do
        let!(:user) { create(:user, :create, phone: nil) }
        let(:user_params) { attributes_for(:user, :create, email: user.email, phone: nil) }

        it { is_expected.to be_instance_of OpenStruct }
        it 'doesn\'t create user' do
          expect { subject }.to_not change(User, :count)
        end
        it_behaves_like 'missing fields'
      end
    end

    context 'with phone provided' do
      context 'and has not been taken' do
        let(:user_params) { attributes_for(:user, :create, email: nil) }

        it { is_expected.to be_instance_of OpenStruct }
        it 'creates user' do
          expect { subject }.to change(User, :count).by(1)
        end
        it_behaves_like 'provided fields'
      end

      context 'and has been taken' do
        let!(:user) { create(:user, :create, email: nil) }
        let(:user_params) { attributes_for(:user, :create, phone: user.phone, email: nil) }

        it { is_expected.to be_instance_of OpenStruct }
        it 'doesn\'t create user' do
          expect { subject }.to_not change(User, :count)
        end
        it_behaves_like 'missing fields'
      end
    end

    context 'with email and phone are missing' do
      let(:user_params) { attributes_for(:user, :create, email: nil, phone: nil) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'doesn\'t create user' do
        expect { subject }.to_not change(User, :count)
      end
      it_behaves_like 'missing fields'
    end
  end
end
