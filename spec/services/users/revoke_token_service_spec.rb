# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RevokeTokenService do
  describe '#call' do
    let(:user) { create :user, :create }
    let(:params) { { current_user: user } }
    subject(:perform_service) { described_class.perform(params) }

    context 'with correct params' do
      context 'and correct token' do
        let!(:token) { Devise::JWT::TestHelpers.auth_headers({}, user) }

        it 'invalidate token' do
          perform_service
          expect do
            Warden::JWTAuth::UserDecoder.new.call(token['Authorization'].split[1], :user, nil)
          end.to raise_error Warden::JWTAuth::Errors::RevokedToken
        end
      end

      it 'changes users jti field' do
        expect { perform_service }.to change(user, :jti)
      end
    end

    context 'with wrong params' do
      subject(:perform_service) { described_class.perform }

      context 'and correct token' do
        let!(:token) { Devise::JWT::TestHelpers.auth_headers({}, user) }

        it 'doesn\'t invalidate token' do
          perform_service
          expect do
            Warden::JWTAuth::UserDecoder.new.call(token['Authorization'].split[1], :user, nil)
          end.to_not raise_error
        end
      end

      it 'doesn\' change users jti field' do
        expect { perform_service }.to_not change(user, :jti)
      end
    end
  end
end
