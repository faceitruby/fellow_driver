# frozen_string_literal: true

# class for serialize model to json
class UserPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[id email phone encrypted_password reset_password_token reset_password_sent_at
                        remember_created_at created_at updated_at jti provider uid first_name last_name
                        address avatar invitation_token invitation_created_at invitation_sent_at
                        invitation_accepted_at invitation_limit invited_by_type invited_by_id
                        invitations_count family_id member_type notifications_enabled].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def page_context
    result = properties
    result.merge!(avatar: url_helpers.rails_blob_path(record.avatar, only_path: true)) if record.avatar.attached?
    result
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES)
  end
end
