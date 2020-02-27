# frozen_string_literal: true

class MemberPresenter
  def initialize(object)
    @object = object
  end

  def as_json(email=nil, *)
    {
        first_name: @object.first_name,
        last_name: @object.last_name,
        phone: @object.phone,
        email: @object.email,
        birth_day: @object.birth_day,
        relationship: @object.relationship
    }
  end
end
