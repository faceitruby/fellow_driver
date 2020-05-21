# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthFacebookService do
  describe '#call' do
    let(:result) do
      {
        'email' => Faker::Internet.email,
        'id' => Faker::Number.number(digits: 15)
      }
    end
    let(:email) { Faker::Internet.email }
    let(:params) { { 'access_token' => 'token_sample' } }
    subject { described_class.new(params).call }

    before do
      allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me?fields=email').and_return(result)
    end

    context 'when facebook returns email ' do
      let(:result) { { 'email' => Faker::Internet.email, 'id' => Faker::Number.number(digits: 15) } }

      context 'and email has been taken' do
        let!(:user) { create(:user, :create, uid: result['id'], email: email) }
        let(:email) { 'email@example.com' }

        it('doesn\'t create user') { expect { subject }.to_not change(User, :count) }
        it('returns token') { expect(subject).to be_instance_of String }
      end

      context 'and email has not been taken' do
        it('creates user') { expect { subject }.to change(User, :count).by(1) }
        it('returns token') { expect(subject).to be_instance_of String }
      end
    end

    context 'when facebook doesn\'t returns email' do
      let(:result) { { 'id' => Faker::Number.number(digits: 15) } }

      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
      it('doesn\'t create user') { expect { subject_ignore_exceptions }.to_not change(User, :count) }
      it('returns nil') { expect(subject_ignore_exceptions).to be nil }
    end

    context 'without facebook token' do
      let(:params) { { access_token: nil } }

      it { expect { subject }.to raise_error ArgumentError }
    end
  end
end
