class Notification < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :body, :status

  private

  def presenter_class
    NotificationPresenter
  end
end
