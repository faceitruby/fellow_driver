# frozen_string_literal: true

class DriverCandidatePresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id updated_at created_at driver_id ride_id second_connection status].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
