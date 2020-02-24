# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :birth_day, :relationship, presence: true
  validate :email_or_phone
  # validates :relationship, inclusion: %w(daughter son husband wife)      #may be
  private

  def email_present?
    email.present?
  end

  def phone_present?
    phone.present?
  end

  def email_or_phone
    errors.add(:email_or_phone, 'Fill in the email or phone field') if email.blank? && phone.blank?
  end
end
