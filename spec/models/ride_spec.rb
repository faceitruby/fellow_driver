# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'fields' do
    %i[passengers start_address end_address date payment message].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end
end
