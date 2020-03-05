# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CarDeleteService' do
  context 'when car exist' do
    subject { Cars::CarDeleteService.new(car_params).call }
    it { expect(subject.data).to eq({message: 'deleted'}) }
    it { expect(subject.errors).to eq(nil) }
    it { expect(subject.success?).to be true }
  end

  context 'when no exist' do
    subject { Cars::CarDeleteService.new.call }
    it { expect(subject.data).to eq(nil) }
    it { expect(subject.errors).to eq('Something went wrong') }
    it { expect(subject.success?).to be false }
  end
end

def car_params
  {
    car: create(:car)
  }
end
