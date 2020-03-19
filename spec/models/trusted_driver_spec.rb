require 'rails_helper'

RSpec.describe TrustedDriver, type: :model do
  describe 'columns' do
    %i[trusted_driver_id trust_driver_id].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    %i[trusted_driver trust_driver].each do |association|
      it { is_expected.to belong_to(association) }
    end
  end
end
