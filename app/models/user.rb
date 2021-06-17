# frozen_string_literal: true

class User < ApplicationRecord
  MEMBER_TYPES = %i[mother father son daughter owner].freeze

  scope :without_car, -> { left_outer_joins(:cars).where(cars: { id: nil }) }
  scope :without_trusted_drivers, -> { left_outer_joins(:trusted_drivers).where(trusted_drivers: { id: nil }) }
  scope :existing_user, ->(phone, email) { where('phone = ?', phone).or(where('email = ?', email)) }

  attr_writer :login

  enum member_type: MEMBER_TYPES

  belongs_to :family
  has_many :cars, dependent: :destroy

  has_many :devices, dependent: :destroy

  has_many :trusted_drivers,
           foreign_key: :trust_driver_id,
           class_name: 'TrustedDriver'
  has_many :trust_drivers,
           foreign_key: :trusted_driver_id,
           class_name: 'TrustedDriver'

  has_many :trusted_driver_requests_as_requestor,
           foreign_key: :requestor_id,
           class_name: 'TrustedDriverRequest'
  has_many :trusted_driver_requests_as_receiver,
           foreign_key: :receiver_id,
           class_name: 'TrustedDriverRequest'
  has_many :requestor_user_family_connections,
           class_name: 'FamilyConnection',
           foreign_key: :requestor_user_id
  has_many :receiver_user_family_connections,
           class_name: 'FamilyConnection',
           foreign_key: :receiver_user_id

  accepts_nested_attributes_for :family
  has_one_attached :avatar
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_present?
  validates :phone, uniqueness: true,
                    format: {
                      with: /\A(\+[0-9]{1,2})?\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}\z/,
                      message: 'Phone numbers must be in xxx-xxx-xxxx format.'
                    }, if: :phone_present?
  validate :email_or_phone
  validates :password, presence: true, on: :create, if: -> { provider.blank? }
  validates :member_type, presence: true, on: :create
  validates_presence_of :first_name, :last_name, :email, :phone, :avatar, :address, on: :update
  validate :avatar_attached?, on: :update
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :jwt_authenticatable,
         jwt_revocation_strategy: self

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

  def name
    "#{first_name} #{last_name}".strip
  end

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
