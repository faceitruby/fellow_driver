# frozen_string_literal: true

class DevicePresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id user_id registration_ids platform created_at updated_at].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def device_page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end

