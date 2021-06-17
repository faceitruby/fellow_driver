class AddStripeCustomerIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :exp_month, :integer
    add_column :users, :exp_year, :integer
    add_column :users, :last4, :string
  end
end
