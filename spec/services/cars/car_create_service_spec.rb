# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cars::CarCreateService do
  let(:user) { create(:user) }
  let(:car_params) { attributes_for :car }
  context 'when car params valid' do
    subject { described_class.perform(car_params.merge(user: user)) }
    it { expect(subject.class).to eq(Car) }
    it { expect { subject }.to change(Car, :count).by(1) }
    it { expect { subject }.to_not raise_error }
  end

  context 'when car params invalid' do
    %w[manufacturer model year picture color license_plat_number].each do |field|
      context "response for invalid #{field}" do
        let(:invalid_params) do
          car_params[field] = nil
          car_params
        end

        subject { described_class.perform(invalid_params.merge(user: user)) }

        it { expect { subject_ignore_exceptions }.to change(Car, :count).by(0) }
        it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
      end
    end
  end
end
