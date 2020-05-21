# frozen_string_literal: true

class TrustedDriver < ApplicationRecord
  belongs_to :trusted_driver, class_name: 'User' # user which will be a friend for trust_driver
  belongs_to :trust_driver, class_name: 'User' # user which requests a friend

  validates_uniqueness_of :trusted_driver, scope: :trust_driver, message: 'record not unique'
end
