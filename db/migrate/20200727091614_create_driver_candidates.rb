class CreateDriverCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :driver_candidates do |t|
      t.references :driver, foreign_key: { to_table: :users }
      t.references :ride, null: false, foreign_key: true
      t.boolean :second_connection, default: false
      t.integer :status, limit: 1, default: 0, null: false

      t.index [:driver_id, :ride_id], unique: true
      t.timestamps
    end
  end
end
