# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :phone, :birth_day, :relationship, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates_format_of :phone,
                      with: /\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}/,
                      message: 'Phone numbers must be in xxx-xxx-xxxx format.'
  validates_format_of :birth_day,
                      with: /(\d{2})\.(\d{2})\.(\d{4})/,
                      message: 'Birth date must be in xx.xx.xxxx format.'
  validates :relationship, inclusion: %w(daughter son husband wife father mother)
end
