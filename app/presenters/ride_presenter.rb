# frozen_string_literal: true

class RidePresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id requestor_id passengers date start_address end_address payment min_payment status].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def page_context
    properties.merge(requestor: requestor_fields).except(:requestor_id)
  end

  private

  def requestor_fields
    User.find(record.requestor_id).present.page_context
  end

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
