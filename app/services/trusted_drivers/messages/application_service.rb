# frozen_string_literal: true

# ApplicationService with jwt_encode and jwt_decode methods
class TrustedDrivers::Messages::ApplicationService < ApplicationService
  private

  def user_receiver
    params[:user_receiver].presence
  end

  def current_user
    params[:current_user].presence
  end
end
