# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Family, type: :model do
  describe 'columns' do
    %i[id created_at updated_at].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'assotiation' do
    it { is_expected.to have_many(:users) }
  end
end
