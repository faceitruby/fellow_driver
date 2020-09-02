# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthFacebookService do
  describe '#call' do
    let(:result) do
      {
        email: Faker::Internet.email,
        id: Faker::Number.number(digits: 15)
      }.stringify_keys
    end
    let(:email) { Faker::Internet.email }
    let(:params) { { access_token: 'token_sample' }.stringify_keys }
    subject { described_class.new(params).call }

    before do
      allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me?fields=email').and_return(result)
    end

    context 'when facebook returns email ' do
      let(:result) { { email: Faker::Internet.email, id: Faker::Number.number(digits: 15) }.stringify_keys }

      context 'and email has been taken' do
        let!(:user) { create(:user, :create, uid: result['id'], email: email) }
        let(:email) { 'email@example.com' }

        it { expect { subject }.to_not change(User, :count) }
        it 'returns token' do
          expect(subject).to be_instance_of String
        end
      end

      context 'and email has not been taken' do
        it { expect { subject }.to change(User, :count).by(1) }
        it 'returns token' do
          expect(subject).to be_instance_of String
        end
      end
    end

    context 'when facebook doesn\'t returns email' do
      let(:result) { { id: Faker::Number.number(digits: 15) }.stringify_keys }

      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
      it { expect { subject_ignore_exceptions }.to_not change(User, :count) }
    end

    context 'without facebook token' do
      let(:params) { { access_token: nil } }

      it { expect { subject }.to raise_error ArgumentError }
    end
  end
end
