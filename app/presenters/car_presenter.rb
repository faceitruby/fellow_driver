# frozen_string_literal: true

class CarPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[manufacturer model year color license_plat_number].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def cars_page_context
    properties.to_json
  end

  private

  def properties
    record.attributes.slice(*MODEL_ATTRIBUTES)
  end
end
