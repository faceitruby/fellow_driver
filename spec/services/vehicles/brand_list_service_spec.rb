# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicles::BrandListService do
  it 'returns Array' do
    allow_any_instance_of(Vehicles::BrandListService).to receive(:examples).and_return(['asd', 'ads'])
    expect(Vehicles::BrandListService.new.call.class).to eq(Array)
  end

  it 'returns Array contain both response' do
    allow_any_instance_of(Vehicles::BrandListService).to receive(:examples).and_return(['asd', 'ads'])
    expect(Vehicles::BrandListService.new.call).to eq(['asd', 'ads', 'asd', 'ads'])
  end
end
