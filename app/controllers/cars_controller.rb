# frozen_string_literal: true

# Controller for CRUD actions with user's cars
class CarsController < ApplicationController
  before_action :find_car, only: %i[show destroy]

  def index
    render_response(current_user.cars.with_attached_picture.map { |car| car.present.cars_page_context })
  end

  def show
    render_response(@car.present.cars_page_context)
  end

  def create
    result = Cars::CarCreateService.perform(car_params.merge(user: current_user))

    render_success_response({ car: result.present.cars_page_context }, :created)
  end

  def destroy
    Cars::CarDeleteService.perform(car: @car)

    render_success_response
  end

  private

  def car_params
    params.require(:car).permit(:manufacturer, :model, :year, :picture, :color, :license_plat_number)
  end

  def find_car
    @car = Car.find(params[:id])
  end
end
