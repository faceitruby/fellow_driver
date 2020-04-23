class CreateTrustedDriver < ActiveRecord::Migration[6.0]
  def change
    create_table :trusted_drivers do |t|
      t.integer :trusted_driver_id
      t.integer :trust_driver_id
    end
  end
end
