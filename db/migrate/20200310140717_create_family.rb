class CreateFamily < ActiveRecord::Migration[6.0]
  def change
    create_table :families do |t|
      t.timestamps
    end

    add_reference :users, :family, null: true, foreign_key: true
    add_column :users, :member_type, :integer
  end
end
