# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamilyConnection, type: :model do
  describe 'columns' do
    %i[id requestor_user_id receiver_user_id accepted created_at updated_at].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end

  describe 'associations' do
    %i[requestor_user receiver_user].each do |user|
      it { is_expected.to belong_to(user) }
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:member_type) }
  end
end
