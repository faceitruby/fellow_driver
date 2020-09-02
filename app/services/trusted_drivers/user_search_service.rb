# frozen_string_literal: true

module TrustedDrivers
  class UserSearchService < ApplicationService
    # @attr_reader params [Hash]
    # - phone: [String] Invited user's phone
    # - uid: [String] Invited user's uid
    # - email: [String] Invited user's email

    def call
      find_through_email || find_through_uid || find_through_phone
    end

    private

    def phone
      params[:phone].presence
    end

    def uid
      params[:uid].presence
    end

    def email
      params[:email].presence
    end

    def find_through_email
      return unless email

      User.find_by(email: email)
    end

    def find_through_uid
      return unless uid

      User.find_by(uid: uid)
    end

    def find_through_phone
      return unless phone

      User.find_by(phone: phone)
    end
  end
end
