class RemoveKindAddReferencesToRideMessage < ActiveRecord::Migration[6.0]
  def change
    remove_column :ride_messages, :kind, :integer, limit: 1
    add_reference :ride_messages, :ride_template, foreign_key: true, null: true
    add_reference :ride_messages, :ride, foreign_key: true, null: false
  end
end
