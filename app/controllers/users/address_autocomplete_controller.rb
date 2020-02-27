# frozen_string_literal: true

module Users
  class AddressAutocompleteController < ApplicationController
    def complete
      result = Users::AddressAutocompleteService.perform(autocomplete_params)
      result.success? ? render_success_response(result.data) : render_error_response(result.errors, 422)
    end

    private

    def autocomplete_params
      params.require(:search).permit(:input, :language, :radius, :types, :lat, :lng)
            .merge(token: request.headers['token'])
    end
  end
end
