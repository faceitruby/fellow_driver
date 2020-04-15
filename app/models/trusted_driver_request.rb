class TrustedDriverRequest < ApplicationRecord
  belongs_to :requestor, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validate :trusted_driver, on: create
  validate :not_trusted_driver_requested, on: create

  private

  def presenter_class
    TrustedDriverRequestPresenter
  end

  def trusted_driver
    errors.add(:alredy_trusted_driver, 'This user is already a trusted driver for you') if TrustedDriver.find_by(trusted_driver_id: receiver_id ,trust_driver_id: requestor_id)
  end

  def not_trusted_driver_requested
    errors.add(:alredy_requested, 'This user is already requested as trusted driver') if TrustedDriverRequest.find_by(receiver_id: receiver_id ,requestor_id: requestor_id)
  end
end
