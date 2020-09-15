class CreateRides < ActiveRecord::Migration[6.0]
  def change
    create_table :rides do |t|
      t.references :requestor, foreign_key: { to_table: :users }
      t.integer :passengers, array: true, default: []
      t.integer :status, limit: 1, default: 0, null: false
      t.string :start_address
      t.string :end_address
      t.datetime :date
      t.integer :payment
      t.integer :min_payment, default: 10

      t.timestamps
    end
  end
end
