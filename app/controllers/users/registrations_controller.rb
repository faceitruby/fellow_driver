# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST api/users/signup
  def create
    Users::RegistrationsService.create_user
  end
end
