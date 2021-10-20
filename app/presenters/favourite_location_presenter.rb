# frozen_string_literal: true

class FavouriteLocationPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id user_id name address description created_at updated_at].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def favourite_locations_page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
