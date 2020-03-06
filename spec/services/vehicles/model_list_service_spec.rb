# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicles::ModelListService do

  subject {
    models_list_service = Vehicles::ModelListService.new(Faker::Vehicle.manufacture)
    allow(models_list_service).to receive(:examples).and_return(['asd', 'ads'])
    models_list_service
  }

  it { expect(subject.call.class).to eq(Array) }

  it 'returns Array contain all models for brand' do
    expect(subject.call).to eq(['asd', 'ads'])
  end
end
