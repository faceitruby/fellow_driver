class RideMessage < ApplicationRecord
  enum kind: { template: 0, custom: 1 }

  # FIXUP: SKIP VALIDATION ONLY FOR TEMPLATE KIND MESSAGES
  belongs_to :ride, optional: true

  # validates_associated :ride #, if: -> {pp '-'*50;pp kind; pp kind == 'custom';kind == 'custom' }
end
