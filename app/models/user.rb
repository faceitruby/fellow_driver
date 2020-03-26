# frozen_string_literal: true

class User < ApplicationRecord
  has_one :family
  has_many :cars, dependent: :destroy
  has_many :payments, dependent: :destroy

  attr_writer :login
  has_one_attached :avatar
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_present?
  validates_format_of :phone,
                      with: /\A\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}\z/,
                      message: 'Phone numbers must be in xxx-xxx-xxxx format.', if: :phone_present?
  validate :email_or_phone
  validates :password, presence: true, on: :create, if: -> { provider.blank? }
  validates_presence_of :first_name, :last_name, :email, :phone, :avatar, :address, on: :update
  # Uniqueness can`t be checked on create, because user inputs only one of email|phone, and other is nil.
  # Validation always be failed with nil is not unique
  validates_uniqueness_of :email, :phone, on: :update
  validate :avatar_attached?, on: :update
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  # rubocop:disable Lint/AssignmentInCondition
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(['lower(phone) = :value OR lower(email) = :value',
                                    { value: login.downcase }]).first
    elsif conditions.key?(:phone) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
  # rubocop:enable Lint/AssignmentInCondition

  private

  def login
    @login || phone || email
  end

  def email_present?
    email.present?
  end

  def phone_present?
    phone.present?
  end

  def email_or_phone
    errors.add(:email_or_phone, 'Fill in the email or phone field') if email.blank? && phone.blank?
  end

  def avatar_attached?
    avatar.attached?
  end

  def presenter_class
    UserPresenter
    InvitePresenter
  end
end
