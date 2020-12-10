# frozen_string_literal: true

class FamilyConnectionsController < ApplicationController
  def index
    receiver_user = current_user.receiver_user_family_connections

    render_response(receiver_user.map { |connection| connection.present.family_connection_page_context })
  end

  def update
    result = Connections::FamilyConnections::UpdateService.perform(update_params)

    render_success_response({ connection: result.present.family_connection_page_context }, :accepted)
  end

  private

  def update_params
    { connection: current_connection }
  end

  def current_connection
    current_user.receiver_user_family_connections.find(params[:id])
  end
end
