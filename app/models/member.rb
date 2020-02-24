# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :birth_day, :relationship, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_present?
  validates_format_of :phone,
                      with: /\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}/,
                      message: 'Phone numbers must be in xxx-xxx-xxxx format.', if: :phone_present?
  validate :email_or_phone
  validates_format_of :birth_day,
                      with: /(\d{2})\.(\d{2})\.(\d{4})/,
                      message: 'Birth date must be in xx.xx.xxxx format.'
  validates :relationship, inclusion: %w(daughter son husband wife father mother)

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
