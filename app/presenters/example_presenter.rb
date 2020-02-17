# frozen_string_literal: true

class ExamplePresenter < ApplicationPresenter
    MODEL_ATTRIBUTES = %i[example_model_attribute].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def examples_page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
