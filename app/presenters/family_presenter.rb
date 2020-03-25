
class FamilyPresenter < ApplicationPresenter
  MODEL_ATTRIBUTES = %i[user_id member_type].freeze

  delegate(*MODEL_ATTRIBUTES, to: :record)

  def family_page_context
    users_data
    properties
  end

  private

  def properties
    record.attributes.symbolize_keys.slice(*MODEL_ATTRIBUTES).merge(
        name: @member_data[:name],
        phone: @member_data[:phone],
        email: @member_data[:email],
        address: @member_data[:address]
    )
  end

  def users_data
    user = User.find(record.user_id)
    @member_data = {
        name: user.first_name + ' ' + user.last_name,
        phone: user.phone,
        email: user.email,
        address: user.address
    }
  end
end
