# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Device, type: :model do
  describe 'field' do
    %i[id user_id registration_ids platform created_at updated_at].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
