# frozen_string_literal: true

module Users
  class DistanceMatrixController < ApplicationController
    # POST /api/users/distance_time/calculate
    def calculate
      result = Users::DistanceMatrixService.perform(points_params)

      render_success_response(data: result)
    end

    private

    def points_params
      params.require(:distance).permit(:origin, :destination)
    end
  end
end

