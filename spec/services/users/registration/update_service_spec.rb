# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'fields changes' do
  it 'changes user' do
    expect do
      subject_ignore_exceptions
      user.reload # ensure attributes changes in DB, not only in user variable
    end.to change(user, :first_name)
      .and change(user, :last_name)
      .and change(user, :address)
      .and change(user, :avatar_attached?)
      .and change(user, :email)
      .and change(user, :phone)
  end
end

RSpec.shared_examples 'avoid fields changes' do
  it 'doesn\'t change user' do
    expect do
      subject_ignore_exceptions
      user.reload # we need to reload because attributes changes in user variable (but doesn`t change in DB)
    end.to avoid_changing(user, :first_name)
      .and avoid_changing(user, :last_name)
      .and avoid_changing(user, :address)
      .and avoid_changing(user, :avatar_attached?)
      .and avoid_changing(user, :email)
      .and avoid_changing(user, :phone)
  end
end

RSpec.describe Users::Registration::UpdateService do
  describe '#call' do
    let(:user) { create(:user, :create, phone: nil) }
    subject { described_class.new(user_params).call }

    before { allow_any_instance_of(described_class).to receive(:user).and_return(user) }

    context 'with all fields provided' do
      let(:user_params) { attributes_for(:user) }

      it_behaves_like 'fields changes'
      it { is_expected.to be_instance_of User }
    end

    context 'with missing params' do
      %i[first_name last_name address avatar phone].each do |field|
        context "when #{field} is nil" do
          let(:user_params) { attributes_for(:user, field => nil) }

          it_behaves_like 'avoid fields changes'
          it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
        end
      end

      context 'when email is nil' do
        let(:user) { create(:user, :create, email: nil) }
        let(:user_params) { attributes_for(:user, email: nil) }

        it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
      end
    end

    context 'with missing params' do
      %i[first_name last_name address avatar phone].each do |field|
        context "when #{field} is missing" do
          let(:user_params) { attributes_for(:user).except(field) }

          it_behaves_like 'avoid fields changes'
          it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
        end
      end
      context 'when email is missing' do
        let(:user) { create(:user, :create, email: nil) }
        let(:user_params) { attributes_for(:user).except(:email) }

        it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
      end
    end
  end
end
