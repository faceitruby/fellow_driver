# frozen_string_literal: true

module Payments
  module Customers
    class CreateService < Payments::ApplicationService
      # @attr_reader params [Hash]
      # - user: [User] Current user
      # - stripeToken: [Hash] Token from Stripe

      def call
        raise ArgumentError, 'Stripe token is required!' unless stripe_token

        customer = find_or_create_customer
        update_user_information(customer)
      end

      private

      def find_or_create_customer
        if user.stripe_customer_id
          stripe_customer = Stripe::Customer.retrieve({ id: user.stripe_customer_id })
          stripe_customer = Stripe::Customer.update(stripe_customer.id, { source: stripe_token }) if stripe_customer
        else
          stripe_customer = Stripe::Customer.create({
                                                      email: user.email,
                                                      source: stripe_token
                                                    })
        end
        stripe_customer
      end

      def update_user_information(customer)
        user.assign_attributes(stripe_customer_id: customer[:id],
                               last4: customer[:sources][:data].first[:last4],
                               exp_month: customer[:sources][:data].first[:exp_month],
                               exp_year: customer[:sources][:data].first[:exp_year])
        user.save!
      end

      def stripe_token
        params[:stripeToken].presence
      end
    end
  end
end
