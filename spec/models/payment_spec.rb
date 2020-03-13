# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'columns' do
    %i[payment_type user_payment user_id].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    %i[user].each do |association|
      it { is_expected.to belong_to(association) }
    end
  end
end
