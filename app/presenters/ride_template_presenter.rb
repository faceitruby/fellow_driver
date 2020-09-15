# frozen_string_literal: true

class RideTemplatePresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id text].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
