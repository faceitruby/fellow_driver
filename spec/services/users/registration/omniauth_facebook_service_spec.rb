# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthFacebookService do
  describe '#call' do
    let(:result) do
      {
        'email' => email,
        'id' => Faker::Number.number(digits: 15)
      }
    end
    let(:email) { Faker::Internet.email }
    let(:params) { { access_token: 'token_sample' } }
    subject { described_class.new(params).call }

    before do
      expect_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me?fields=email').and_return(result)
    end

    context 'when email returns from facebook' do
      context 'and email has been taken' do # returns
        let!(:user) { create(:user, :create, uid: result['id'], email: email) }
        let(:email) { 'email@example.com' }

        it { is_expected.to be_instance_of OpenStruct }
        it 'doesn\'t create user' do
          expect { subject }.to_not change(User, :count)
        end
        it_behaves_like 'provided fields'
        it 'returns existing user' do
          expect(subject.data[:user]['email']).to eq user.email
        end
        it 'returns token' do
          expect(subject.data[:token]).to be_present
        end
      end

      context 'and email has not been taken' do
        it { is_expected.to be_instance_of OpenStruct }
        it 'creates user' do
          expect { subject }.to change(User, :count).by(1)
        end
        it_behaves_like 'provided fields'
        it 'returns new user' do
          expect(subject.data[:user]).to be_present
        end
        it 'returns token' do
          expect(subject.data[:token]).to be_present
        end
      end
    end

    context 'when email doesn\'t returns from facebook' do
      let(:result) { { 'id' => Faker::Number.number(digits: 15) } }

      it { is_expected.to be_instance_of OpenStruct }
      it 'doesn\'t create user' do
        expect { subject }.to_not change(User, :count)
      end
      it_behaves_like 'missing fields'
    end
  end
end
