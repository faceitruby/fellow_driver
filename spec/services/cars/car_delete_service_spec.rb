# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cars::CarDeleteService do
  describe '#call' do
    context 'when car exist' do
      let!(:car) { create(:car) }
      subject { described_class.perform(car: car) }

      it { expect { subject }.to_not raise_error }
      it { expect { subject }.to change(Car, :count).by(-1) }
      it { expect(subject.destroyed?).to be true }
    end

    context 'when no exist' do
      subject { described_class.perform }

      it { expect { subject }.to raise_error ActiveRecord::RecordNotFound }
      it { expect { subject_ignore_exceptions }.to_not change(Car, :count) }
    end

    context 'when car is already deleted' do
      let(:car) { create(:car) }
      subject { described_class.perform(car: car) }

      before { car.destroy }

      it { expect { subject }.to_not raise_error }
      it { expect { subject }.to_not change(Car, :count) }
      it { expect(subject.destroyed?).to eq true }
    end
  end
end
