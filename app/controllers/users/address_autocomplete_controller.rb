# frozen_string_literal: true

module Users
  class AddressAutocompleteController < ApplicationController
    # POST /api/users/address_autocomplete/complete
    def complete
      result = Users::AddressAutocompleteService.perform(autocomplete_params)

      render_success_response(predictions: result)
    end

    private

    def autocomplete_params
      params.require(:search).permit(:input, :language, :radius, :types, :lat, :lng)
            .merge(token: request.headers['token'])
    end
  end
end
