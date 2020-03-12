# frozen_string_literal: true

class InvitePresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[first_name last_name phone email invited_by_id family_id].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def invite_page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
