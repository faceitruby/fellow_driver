# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Customers::CreateService do
  describe '#call' do
    subject { described_class.perform(customer_params.merge(user: user)) }
    let(:user) { create(:user) }
    let(:expected_response) do
      {
        'id': 'cus_JgFW4u23EN8uDd',
        'object': 'customer',
        'created': 1_623_827_952,
        'default_source': 'card_1J2t1oGsPwe4QSISGMkslnkl',
        'email': 'meda_marvin@hotmail.com',
        'sources': {
          'object': 'list',
          'data':
            [{
              'id': 'card_1J2t1oGsPwe4QSISGMkslnkl',
              'object': 'card',
              'brand': 'Visa',
              'customer': 'cus_JgFW4u23EN8uDd',
              'exp_month': 6,
              'exp_year': 2022,
              'last4': '4242'
            }]
        }
      }
    end

    context 'with valid params' do
      let(:customer_params) { { stripeToken: 'tok_visa' } }

      before { allow(Stripe::Customer).to receive(:create).and_return(expected_response) }

      it { expect { subject }.to change(user, :stripe_customer_id).from(nil).to('cus_JgFW4u23EN8uDd') }

      it { expect { subject }.to change(user, :exp_month).from(nil).to(6) }

      it { expect { subject }.to change(user, :exp_year).from(nil).to(2022) }

      it { expect { subject }.to change(user, :last4).from(nil).to('4242') }
    end

    context 'without Stripe Token' do
      let(:customer_params) { { stripeToken: nil } }

      it { expect { subject }.to raise_error(ArgumentError, 'Stripe token is required!') }
    end
  end
end
