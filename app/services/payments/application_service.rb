# frozen_string_literal: true

# ApplicationService with common methods for vehicles
module Payments
  class ApplicationService < ApplicationService
    private

    def user
      params[:user].presence
    end
  end
end
