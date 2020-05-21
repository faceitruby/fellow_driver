# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Layout/MultilineMethodCallIndentation
RSpec.shared_examples 'success creation' do
  it do
    expect { subject }
      .to change(User, :count).by(1)
      .and avoid_raising_error
  end
  it('returns true') { is_expected.to be true }
end
# rubocop:enable Layout/MultilineMethodCallIndentation

RSpec.shared_examples 'failure creation' do
  it do
    expect { subject }
      .to raise_error(ActiveRecord::RecordInvalid, message)
      .and avoid_changing(User, :count)
  end
  it('returns nil') { expect(subject_ignore_exceptions).to be nil }
end

RSpec.describe Users::Registration::CreateService do
  describe '#call' do
    subject { described_class.new(user_params).call }

    context 'with params in correct format' do
      context 'and email provided' do
        context 'and has not been taken' do
          let(:user_params) { attributes_for(:user, :create).slice(:password, :email).with_indifferent_access }

          include_examples 'success creation'
        end

        context 'and has been taken' do
          let!(:user) { create(:user, :create, phone: nil) }
          let(:user_params) do
            attributes_for(:user, :create, email: user.email).slice(:password, :email).with_indifferent_access
          end
          let(:message) { 'Validation failed: Email has already been taken' }

          include_examples 'failure creation'
        end
      end

      context 'and phone provided' do
        context 'and has not been taken' do
          let(:user_params) { attributes_for(:user, :create).slice(:password, :phone).with_indifferent_access }

          include_examples 'success creation'
        end

        context 'and has been taken' do
          let!(:user) { create(:user, :create, email: nil) }
          let(:user_params) do
            attributes_for(:user, :create, phone: user.phone).slice(:password, :phone).with_indifferent_access
          end
          let(:message) { 'Validation failed: Phone has already been taken' }

          include_examples 'failure creation'
        end
      end

      context 'and login provided' do
        context 'with email' do
          context 'and has not been taken' do
            let(:user_params) do
              attributes_for(:user, :create, login: Faker::Internet.email).slice(:password, :login)
                                                                          .with_indifferent_access
            end

            include_examples 'success creation'
          end

          context 'and has been taken' do
            let!(:user) { create(:user, :create) }
            let(:user_params) do
              attributes_for(:user, :create, login: user.email).slice(:password, :login)
                                                               .with_indifferent_access
            end
            let(:message) { 'Validation failed: Email has already been taken' }

            include_examples 'failure creation'
          end
        end

        context 'with phone' do
          context 'and has not been taken' do
            let(:user_params) do
              attributes_for(:user, :create, login: Faker::Base.numerify('###-###-####')).slice(:password, :login)
                                                                                         .with_indifferent_access
            end

            include_examples 'success creation'
          end

          context 'and has been taken' do
            let!(:user) { create(:user, :create) }
            let(:user_params) do
              attributes_for(:user, :create, login: user.phone).slice(:password, :login)
                                                               .with_indifferent_access
            end
            let(:message) { 'Validation failed: Phone has already been taken' }

            include_examples 'failure creation'
          end
        end
      end
    end

    context 'with missing params' do
      %i[email phone password].each do |param|
        context "when #{param} is missing" do
          let(:user_params) { attributes_for(:user, :create).slice(param).with_indifferent_access }

          it do
            expect { subject }
              .to raise_error(ActiveRecord::RecordInvalid)
              .and avoid_changing(User, :count)
          end
        end
      end

      context 'returns' do
        before { allow(User).to receive(:new).and_raise ActiveRecord::RecordInvalid }

        it('nil') { expect(subject_ignore_exceptions).to be nil }
      end
    end
  end
end
