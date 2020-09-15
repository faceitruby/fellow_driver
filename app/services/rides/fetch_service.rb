# frozen_string_literal: true

module Rides
  class FetchService < ApplicationService
    # @attr_reader params [Hash]
    # - current_user: [User] List of requests searcher
    #
    # + return
    # List ride requests for current user

    def call
      Ride.where(requestor: current_user).to_a
    end

    private

    def current_user
      params[:user].presence
    end
  end
end
