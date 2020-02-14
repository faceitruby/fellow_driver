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
         :recoverable, :rememberable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  private

  def login
    @login || self.phone || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(phone) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:phone) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def email_present?
    !email.empty?
  end

  def phone_present?
    !phone.empty?
  end

  def email_or_phone
    errors.add(:email_or_phone, 'Fill in the email or phone field') if email.empty? && phone.empty?
  end
end
