class Notification < ApplicationRecord
  belongs_to :user

  private

  def presenter_class
    NotificationPresenter
  end
end
