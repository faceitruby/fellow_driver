class CreateFrieds < ActiveRecord::Migration[6.0]
  def change
    create_table :trusted_drivers do |t|
      t.integer :trusted_driver_id
      t.integer :user_id
    end
  end
end
