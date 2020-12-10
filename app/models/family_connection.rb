# frozen_string_literal: true

class FamilyConnection < ApplicationRecord
  MEMBER_TYPES = %i[mother father son daughter owner].freeze

  enum member_type: MEMBER_TYPES

  belongs_to :requestor_user, class_name: 'User'
  belongs_to :receiver_user, class_name: 'User'

  private

  def presenter_class
    FamilyConnectionPresenter
  end
end
