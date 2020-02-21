class MembersController < ApplicationController
  def index
    user = current_user
    members = user.members.all

    render json: members
  end
end
