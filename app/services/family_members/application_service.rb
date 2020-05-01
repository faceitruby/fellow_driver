# frozen_string_literal: true

# ApplicationService with user_receiver and current_user methods
module FamilyMembers
  class ApplicationService < ApplicationService
    private

    def user_receiver
      params[:user_receiver].presence
    end

    def current_user
      params[:current_user].presence
    end
  end
end
