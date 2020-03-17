# frozen_string_literal: true

class User < ApplicationRecord
  has_many :cars, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_and_belongs_to_many :trusted_drivers, class_name: 'User',
                                    join_table: 'trusted_drivers',
                                    association_foreign_key: 'user_id'


  attr_writer :login
  has_one_attached :avatar
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_present?
  validates_format_of :phone,
                      with: /\A\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}\z/,
                      message: 'Phone numbers must be in xxx-xxx-xxxx format.', if: :phone_present?
  validate :email_or_phone
  validates :password, confirmation: true
  validates_presence_of :first_name, :last_name, :email, :phone, :avatar, :address, on: :update
  validate :avatar_attached?, on: :update
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :invitable, :database_authenticatable, :registerable,
        :recoverable, :rememberable, :jwt_authenticatable, :invitable,
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
  end
end
