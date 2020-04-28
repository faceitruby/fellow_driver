# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicles::ModelListService do
  let(:service_response) { %w[asd ads] }
  let(:brand) { Faker::Vehicle.manufacture }

  before do
    allow_any_instance_of(Vehicles::ModelListService).to receive(:examples).and_return(service_response)
  end

  subject { Vehicles::ModelListService.perform(brand) }

  it { expect(subject.class).to eq(Array) }

  it 'returns Array contain all models for brand' do
    expect(subject).to eq(service_response)
  end
end
