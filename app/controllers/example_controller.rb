# frozen_string_literal: true

class ExampleController < ApplicationController
  def index
    render_response(
      Examples::FetchService.perform(params.permit(:example_id, :example_name))
    )
  end
end
