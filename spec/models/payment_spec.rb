require 'rails_helper'

RSpec.describe Payment, type: :model do
  context 'fields' do
    %i[ payment_type user_payment user_id].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  context 'Associations' do
    %i[user].each do |association|
      it 'belongs to user by user_id field' do
        is_expected.to belong_to(association)
      end
    end
  end
end
