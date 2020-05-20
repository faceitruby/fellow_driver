class TrustedDriver < ApplicationRecord
  belongs_to :trusted_driver, class_name: 'User'
  belongs_to :trust_driver, class_name: 'User'
end
