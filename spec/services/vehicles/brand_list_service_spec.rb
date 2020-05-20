# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicles::BrandListService do
  let(:service_response) { %w[asd ads] }
  before do
    allow_any_instance_of(Vehicles::BrandListService).to receive(:examples).and_return(service_response)
  end

  subject { Vehicles::BrandListService.perform }

  it 'returns Array' do
    expect(subject.class).to eq(Array)
  end

  it 'returns Array contain both response' do
    expect(subject).to eq(service_response * 2)
  end
end
