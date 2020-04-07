# frozen_string_literal: true

class FamiliesController < ApplicationController
  skip_before_action :check_authorize

  def index
    family = current_user.family
    render_response(family.present.family_page_context)
  end
end
