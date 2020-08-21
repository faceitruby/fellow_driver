# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'columns' do
    %i[id notification_type status title body subject].each do |field|
      it { is_expected.to have_db_column(field) }
    end
  end
end
