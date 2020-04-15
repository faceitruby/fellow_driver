class CreateRideMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :ride_messages do |t|
      t.string :message
      t.integer :kind, limit: 1
      t.timestamps
    end
  end
end
