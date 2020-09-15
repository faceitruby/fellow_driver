# frozen_string_literal: true

module Rides
  class TemplatesController < ApplicationController
    def index
      templates = Messages::FetchTemplatesService.perform(index_params)
      render_success_response(
        { message_templates: templates.map { |template| template.present.page_context } }
      )
    end

    def show
      template = Rides::Messages::FetchSingleTemplateService.perform(show_params)
      render_success_response({ message_template: template.present.page_context })
    end

    private

    def index_params
      params.require(:message_info).permit(:time,
                                           :start_address,
                                           :end_address,
                                           passengers: [])
    end

    def show_params
      params.permit(:id)
    end
  end
end
