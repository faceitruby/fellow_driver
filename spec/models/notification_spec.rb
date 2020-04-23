require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'field' do
    %i[id user_id title body status type created_at updated_at].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    %i[user].each do |association|
      it { is_expected.to belong_to(association) }
    end
  end
end
