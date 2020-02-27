# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :check_authorize, :set_current_user, only: %i[create index]

  def index
    members = @user.members
    render json: MembersPresenter.new(members)
  end

  def show
    member = Member.find(params[:id])
    render json: MemberPresenter.new(member)
  end

  def create
    member = @user.members.new(member_params)
    if member.save
#       TODO: uncomment when will be @user['first_name'] and @user['last_name']
#       message = "#{@user['first_name']} #{@user['last_name']} added you as family \
# member on FellowDriver. Click the link below to accept the invitation: link."
#       TwilioTextMessenger.new(message).call
      render json: MemberPresenter.new(member)
    else
      render json: member.errors
    end
  end

  private

  def set_current_user
    token = request.headers['token']
    decoded_auth_token = JsonWebToken.decode(token)
    @user = User.find(decoded_auth_token[:user_id])
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email,
                                   :phone, :birth_day, :relationship)
  end
end
