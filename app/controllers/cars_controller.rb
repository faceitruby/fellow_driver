class CarsController < ApplicationController
  before_action :find_current_user, except: %i[show destroy]
  before_action :find_car, only: %i[show destroy]

  def index
    render_response(@user.cars)
  end

  def show
    render_response(@car)
  end

  def create
    @user.cars.create(car_params)
    render_success_response(data = nil, status = :created)
  end

  def destroy
    render_success_response(data = nil, status = :no_content) if @car.destroy
  end

  private

  def car_params
    params.require(:car).permit(:manufacturer, :model, :year, :picture, :color, :license_plat_number)
  end

  def find_current_user
    @user = Users::CurrentUserService.perform(request.headers['token'])
  end

  def find_car
    @car = Car.find(params[:id])
  end
end
