# frozen_string_literal: true

module Payments
  module Charges
    class CreateService < Payments::ApplicationService
      # @attr_reader params [Hash]
      # - user: [User] Current user
      # - amount: [Integer] Amount of money to charge

      def call
        raise ArgumentError, 'Stripe Customer must exist!' unless user.stripe_customer_id

        create_charge
      end

      private

      def create_charge
        Stripe::Charge.create({
                                amount: amount.to_i * 100,
                                currency: 'usd',
                                customer: user.stripe_customer_id
                              })
      end

      def amount
        params[:amount].presence
      end
    end
  end
end
