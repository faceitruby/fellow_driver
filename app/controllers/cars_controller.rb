# frozen_string_literal: true

# Controller for CRUD actions with user's cars
class CarsController < ApplicationController
  before_action :find_car, only: %i[show destroy]

  def index
    render_response(current_user.cars.map { |car| car.present.cars_page_context })
  end

  def show
    render_response(@car.present.cars_page_context)
  end

  def create
    result = Cars::CarCreateService.perform(car_params.merge(user: current_user))
    result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors)
  end

  def destroy
    result = Cars::CarDeleteService.perform(car: @car)
    result.success? ? render_success_response(result.data, :no_content) : render_error_response(result.errors)
  end

  private

  def car_params
    params.require(:car).permit(:manufacturer, :model, :year, :picture, :color, :license_plat_number)
  end

  def find_car
    @car = Car.find(params[:id])
  end
end
