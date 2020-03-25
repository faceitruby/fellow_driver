# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FamiliesController, type: :controller do
  describe 'routing' do
    it { expect(get: '/api/families').to route_to(controller: 'families', action: 'index', format: 'json') }
  end
end
