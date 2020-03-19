# frozen_string_literal: true

class TrustedDriverRequestPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id receiver_id requestor_id].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def request_page_context
    properties.merge(requestor: requestor_fields).except(:requestor_id)
  end

  private

  def requestor_fields
    User.find(properties[:requestor_id]).present.page_context.slice(:id, :email, :avatar, :first_name, :last_name, :phone)
  end

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
