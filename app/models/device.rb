class Device < ApplicationRecord
  belongs_to :user

  private

  def presenter_class
    DevicePresenter
  end
end
