# frozen_string_literal: true

class PaymentPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[payment_type user_payment].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def payments_page_context
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
