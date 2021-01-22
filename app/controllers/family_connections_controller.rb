# frozen_string_literal: true

class FamilyConnectionsController < ApplicationController
  def index
    receiver_user = current_user.receiver_user_family_connections

    render_response(receiver_user.map { |connection| connection.present.family_connection_page_context })
  end

  def update
    Connections::FamilyConnections::UpdateService.perform(update_params.merge(current_user: current_user))

    render_success_response({ message: 'Connection accepted' }, :no_content)
  end

  private

  def update_params
    params.permit(:id)
  end

  def current_connection
    current_user.receiver_user_family_connections.find(params[:id])
  end
end
