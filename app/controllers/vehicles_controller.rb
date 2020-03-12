# frozen_string_literal: true

# Return brands and models avto for avtocomplete
class VehiclesController < ApplicationController
  def brands
    render_response(Vehicles::BrandListService.perform)
  end

  def models
    render_response(Vehicles::ModelListService.perform(params[:brand]))
  end
end
