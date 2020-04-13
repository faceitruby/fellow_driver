# frozen_string_literal: true

class FamilyPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id created_at updated_at].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def family_page_context
    properties.merge(members: family_members)
  end

  private

  def family_members
    record.users.sort
  end

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
