# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicles::ModelListService do
  it { expect(models_stub.call.class).to eq(Array) }

  it 'returns Array contain all models for brand' do
    expect(models_stub.call).to eq(['asd', 'ads'])
  end
end

def models_params
  Faker::Vehicle.manufacture
end

def models_stub
  models_list_service = Vehicles::ModelListService.new(models_params)
  allow(models_list_service).to receive(:examples).and_return(['asd', 'ads'])
  models_list_service
end
