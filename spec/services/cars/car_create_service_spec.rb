# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cars::CarCreateService do
  let(:user) { create(:user) }
  let(:car_params) do
    {
      manufacturer: Faker::Vehicle.manufacture,
      model: Faker::Vehicle.model,
      year: Faker::Number.number(digits: 4),
      picture: Rack::Test::UploadedFile.new('spec/support/assets/test-image.jpeg', 'image/jpeg'),
      color: Faker::Color.hex_color,
      license_plat_number: Faker::Number.number(digits: 4),
    }
  end
  context 'when car params valid' do
    subject { Cars::CarCreateService.perform(car_params.merge(user: user)) }
    it { expect(subject.class).to eq(OpenStruct) }
    it { expect(subject.data[:car].class).to eq(Hash) }
    it { expect(subject.errors).to eq(nil) }
    it { expect(subject.success?).to be true }
    it { expect { subject }.to change(Car, :count).by(1) }
  end

  context 'when car params invalid' do
    %w[manufacturer model year picture color license_plat_number].each do |field|
      context "response for invalid #{field}" do
        let(:invalid_params) do
          car_params[field] = nil
          car_params
        end
        let(:response) { ["can't be blank"] }
        subject { Cars::CarCreateService.perform(invalid_params.merge(user: user)) }

        it { expect(subject.class).to eq(OpenStruct) }
        it { expect(subject.data).to eq(nil) }
        it { expect(subject.success?).to be false }
        it { expect(subject.errors.class).to eq(ActiveModel::Errors) }
        it { expect(subject.errors.messages[field.to_sym]).to eq(response) }
        it { expect { subject }.to change(Car, :count).by(0) }
      end
    end
  end
end
