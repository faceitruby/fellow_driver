# frozen_string_literal: true

# class for serialize model to json
class UserPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id email phone encrypted_password reset_password_token reset_password_sent_at
                        remember_created_at created_at updated_at jti provider uid first_name last_name address invitation_token invitation_created_at invitation_sent_at invitation_accepted_at invitation_limit invited_by_type invited_by_id invitations_count].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def page_context
    properties
    if record.avatar.attached?
      properties.merge(avatar: Rails.application.routes.url_helpers.rails_blob_path(record.avatar, only_path: true))
    end
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
