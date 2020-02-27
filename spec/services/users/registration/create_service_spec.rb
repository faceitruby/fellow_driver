# frozen_string_literal: true

require 'rails_helper'
require 'support/shared/results_shared'

RSpec.describe 'registration create service' do
  describe '#call' do
    subject { Users::Registration::CreateService.new(user_params).call }

    context 'with email provided' do
      let(:user_params) { attributes_for(:user, :create_params_only, phone: nil) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'creates user' do
        expect { subject }.to change(User, :count)
      end
      it_behaves_like 'when fields present'
    end
    context 'with phone provided' do
      let(:user_params) { attributes_for(:user, :create_params_only, email: nil) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'creates user' do
        expect { subject }.to change(User, :count)
      end
      it_behaves_like 'when fields present'
    end
    context 'with email and phone missing' do
      let(:user_params) { attributes_for(:user, :create_params_only, email: nil, phone: nil) }

      it { is_expected.to be_instance_of OpenStruct }
      it 'doesn\'t create user' do
        expect { subject }.to_not change(User, :count)
      end
      it_behaves_like 'when fields missed'
    end
  end
end
