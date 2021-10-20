# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavouriteLocationPresenter do
  let(:location) { create(:favourite_location) }

  describe 'constants' do
    describe 'MODEL_ATTRIBUTES' do
      let(:attributes_list) { %i[id user_id name address description created_at updated_at] }
      subject { described_class::MODEL_ATTRIBUTES }

      it { is_expected.to eq attributes_list }
    end
  end

  describe '#page_content' do
    let(:expected_presenter) { location.attributes.symbolize_keys }
    subject { described_class.new(location).favourite_locations_page_context }

    it { is_expected.to be_instance_of Hash }
    it { is_expected.to eq expected_presenter }
  end

  describe 'delegates' do
    subject { described_class.new(location) }

    described_class::MODEL_ATTRIBUTES.each do |method|
      it { is_expected.to delegate_method(method).to :record }
    end
  end
end
