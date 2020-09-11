class CreateFamilyConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :family_connections do |t|
      t.references :requestor_user, null: false
      t.references :receiver_user, null: false
      t.integer :member_type
      t.boolean :accepted, default: false

      t.timestamps
    end

    add_foreign_key :family_connections, :users, column: :requestor_user_id
    add_foreign_key :family_connections, :users, column: :receiver_user_id
  end
end
