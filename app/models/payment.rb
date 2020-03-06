# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :user

  validates_presence_of :user_payment, :payment_type

  private

  def presenter_class
    PaymentPresenter
  end
end
