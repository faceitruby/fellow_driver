# frozen_string_literal: true

class FamiliesController < ApplicationController
  skip_before_action :check_authorize

  def index
    family = Family.where("owner = ?", current_user.id)
    render_response(family.map { |member| member.present.family_page_context })
  end
end
