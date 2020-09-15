# frozen_string_literal: true

module Rides
  # drivers accepted ride
  class CandidatesController < ApplicationController
    def index
      candidates = Candidates::FetchService.perform(ride_id: ride_id)
      render_success_response(
        candidates: candidates.map { |candidate| candidate.present.page_context }
      )
    end

    # driver accepts ride
    def create
      result = Candidates::CreateService.perform(create_params.merge(status: :accepted))
      if result.is_a? DriverCandidate
        render_success_response({ candidate: result.present.page_context }, :created)
      else
        render_success_response({ data: result })
      end
    end

    # candidate dismisses ride request
    def deny
      Candidates::CreateService.perform(create_params.merge(status: :dismissed_by_candidate))
    end

    # requestor accepts candidate to be ride driver
    def accept
      Candidates::ChangeAcceptedService.perform accept_params.merge(accept: true)
      render_success_response
    end

    # requestor dismiss candidate
    def dismiss
      Candidates::ChangeAcceptedService.perform dismiss_params.merge(accept: false)
      render_success_response
    end

    private

    def create_params
      params.permit(:id).merge(driver_id: current_user.id)
    end

    def accept_params
      params.permit(:id)
    end

    def dismiss_params
      params.permit(:id)
    end

    def ride_id
      params[:id].presence
    end
  end
end
