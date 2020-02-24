class MembersController < ApplicationController
  before_action :check_authorize, :set_current_user, only: [:create, :index]

  def index
    members = @user.members

    render json: members
  end

  def show
    member = Member.find(params[:id])

    render json: member
  end

  def create
    member = @user.members.new(member_params)
    if member.save
      render json: member
    else
      render json: member.errors
    end

    
  end

  private

  def set_current_user
    @user = User.find(@current_user["user_id"])
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :phone, :birth_day, :relationship)
  end
end
