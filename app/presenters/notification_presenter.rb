# frozen_string_literal: true

class NotificationPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id created_at updated_at title body status type].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def notification_page_context
    properties.merge(user: User.find(record.user_id))
  end

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
