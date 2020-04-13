# frozen_string_literal: true

class FamiliesController < ApplicationController

  def index
    family = current_user.family
    render_response(family.present.family_page_context)
  end
end
