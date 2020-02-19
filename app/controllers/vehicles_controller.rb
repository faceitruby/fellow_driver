class VehiclesController < ApplicationController
  def brands
    render_response(Vehicles::BrandService.new.call)
  end

  def models
    render_response(Vehicles::ModelService.new.call(params[:brand]))
  end
end
