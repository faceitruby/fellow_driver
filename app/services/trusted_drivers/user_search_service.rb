# frozen_string_literal: true

module TrustedDrivers
  class UserSearchService < ApplicationService
    # @attr_reader params [Hash]
    # - phone: [String] Invited user's phone
    # - uid: [String] Invited user's uid
    # - email: [String] Invited user's email

    def call
      if find_by_email || find_by_uid || find_by_phone
        OpenStruct.new(success?: true, data: { user: @user }, errors: nil)
      else
        OpenStruct.new(success?: false, data: nil, errors: nil)
      end
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

    def find_by_email
      return unless email

      @user = User.find_by(email: email)
    end

    def find_by_uid
      return unless uid

      @user = User.find_by(uid: uid)
    end

    def find_by_phone
      return unless phone

      @user = User.find_by(phone: phone)
    end
  end
end
