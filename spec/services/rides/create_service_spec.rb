# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rides::CreateService do
  describe '#call' do
    let(:params) do
      {
        passengers: [123, 234],
        start_address: 'проспект Соборный, 16, Запорожье, Запорожская область, Украина',
        end_address: 'проспект Соборный, 120, Запорожье, Запорожская область, Украина',
        date: Time.zone.now
      }
    end

    subject { described_class.new(params).call }  
    
    it do
      subject
    end
    
  end
end