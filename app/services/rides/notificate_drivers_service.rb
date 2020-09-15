# frozen_string_literal: true

module Rides
  class NotificateDriversService < ApplicationService
    # @attr_reader params [Hash] params
    # - id [Integer] User id
    # - second_connection [Boolean] Notificate second connection or first connection drivers?

    def call
      Resque.enqueue(NotificateDriversJob, connection)
    end

    private

    def connection
      params[:second_connection].present? ? second_connection : first_connection
    end

    def second_connection
      user.trusted_drivers.map { |tr| tr.trusted_driver.trusted_drivers }.flatten
    end

    def first_connection
      user.trusted_drivers.to_a
    end

    def user
      @user ||= User.includes(trusted_drivers: { trusted_driver: :trusted_drivers }).find params[:id].presence
    end
  end
end
