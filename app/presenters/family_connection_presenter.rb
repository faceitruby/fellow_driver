# frozen_string_literal: true

class FamilyConnectionPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id requestor_user_id receiver_user_id member_type accepted created_at updated_at].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def family_connection_page_context
    properties
  end

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
