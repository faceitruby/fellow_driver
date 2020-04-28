# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cars::CarDeleteService do
  context 'when car exist' do
    let(:car) { create(:car) }
    subject { described_class.perform(car: car) }
    let(:message) { { message: 'deleted' } }
    it { expect(subject.data).to eq(message) }
    it { expect(subject.errors).to eq(nil) }
    it { expect(subject.success?).to be true }
  end

  context 'when no exist' do
    let(:response_message) { 'Something went wrong' }
    subject { described_class.perform }
    it { expect(subject.data).to eq(nil) }
    it { expect(subject.errors).to eq(response_message) }
    it { expect(subject.success?).to be false }
  end
end
