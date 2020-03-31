# frozen_string_literal: true

# A record with information about a ride
class CreateRides < ActiveRecord::Migration[6.0]
  def change
    create_table :rides do |t|
      t.references :driver, null: false, foreign_key: { to_table: :users }
      t.references :requestor, null: false, foreign_key: { to_table: :users }
      t.integer :passengers, array: true
      t.integer :status, limit: 1
      t.point :start_address
      t.point :end_address
      t.datetime :date
      t.integer :payment
      # FIXUP WE WILL STORE 5 TEMPLATES, AND THERE IS OPPORTUNYTY FOR CUSTOM MESSAGE
      t.text :message
      t.string :city
      t.string :state
    end
  end
end
