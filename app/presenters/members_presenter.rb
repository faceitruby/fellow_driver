# frozen_string_literal: true

class MembersPresenter
  def initialize(object)
    @object = object
  end

  def as_json(*)
    {
        members: @object.map{ |member| MemberPresenter.new(member) }
    }
  end
end
