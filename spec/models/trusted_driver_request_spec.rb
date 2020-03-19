require 'rails_helper'

RSpec.describe TrustedDriverRequest, type: :model do
  describe 'columns' do
    %i[receiver_id requestor_id created_at updated_at].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    %i[requestor receiver].each do |association|
      it { is_expected.to belong_to(association) }
    end
  end
end
