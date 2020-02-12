class User < ApplicationRecord
  attr_writer :login
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_present?
  validates_format_of :phone,
                      with: /\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}/,
                      message: 'Phone numbers must be in xxx-xxx-xxxx format.', if: :phone_present?
  validate :email_or_phone
  validates :password, confirmation: true
  # validates :phone, presence: true
  # validates :phone, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  def login
    @login || self.phone || self.email
  end

  private

  def email_present?
    !email.empty?
  end

  def phone_present?
    !phone.empty?
  end

  def email_or_phone
    errors.add(:email_or_phone, 'Fill in the email or phone field') if
        email.empty? && phone.empty?
  end
end
