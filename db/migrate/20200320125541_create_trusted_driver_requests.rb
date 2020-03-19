class CreateTrustedDriverRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :trusted_driver_requests do |t|
      t.integer :receiver_id
      t.integer :requestor_id
      t.timestamps
    end
  end
end
