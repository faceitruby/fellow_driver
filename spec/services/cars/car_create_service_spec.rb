# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cars::CarCreateService do

  context 'when car params valid' do
    context 'response' do
      subject { Cars::CarCreateService.new(car_create_params).call }
      it { expect(subject.class).to eq(OpenStruct) }
      it { expect(subject.data[:car].class).to eq(Car) }
      it { expect(subject.errors).to eq(nil) }
      it { expect(subject.success?).to be true }
      it { expect { subject }.to change(Car, :count).by(1) }
    end
  end

  context 'when car params invalid' do
    %w[manufacturer model year picture color license_plat_number].each do |field|
      context "response for invalid #{field}" do
        subject { Cars::CarCreateService.new(car_create_params(field)).call }
        it { expect(subject.class).to eq(OpenStruct) }
        it { expect(subject.data).to eq(nil) }
        it { expect(subject.success?).to be false }
        it { expect(subject.errors.class).to eq(ActiveModel::Errors) }
        it { expect(subject.errors.messages[field.to_sym]).to eq(["can't be blank"]) }
        it { expect { subject }.to change(Car, :count).by(0) }
      end
    end
  end
end

def car_create_params(field = nil)
  car_param = {
    'manufacturer': Faker::Vehicle.manufacture,
    'model': Faker::Vehicle.model,
    'year': Faker::Number.number(digits: 4),
    'picture': Rack::Test::UploadedFile.new('spec/support/assets/test-image.jpeg', 'image/jpeg'),
    'color': Faker::Color.hex_color,
    'license_plat_number': Faker::Number.number(digits: 4),
  }
  car_param[field] = nil if field
  car_param.merge('user'=> create(:user))
end
