class CreateFamily < ActiveRecord::Migration[6.0]
  def change
    create_table :families do |t|
      t.integer :user_id
      t.integer :owner
      t.integer :member_type

      t.timestamps
    end
  end
end
