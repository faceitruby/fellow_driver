# frozen_string_literal: true

class CarPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id manufacturer model year color license_plat_number].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def cars_page_context
    properties
    if record.picture.attached?
      properties.merge(picture: Rails.application.routes.url_helpers.rails_blob_path(record.picture, only_path: true))
    end
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
