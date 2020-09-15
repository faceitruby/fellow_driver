# frozen_string_literal: true

class RideMessagePresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id message created_at updated_at].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def ride_message_page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
