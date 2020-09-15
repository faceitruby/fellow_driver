class AddRideTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :ride_templates do |t|
      t.text :text, unique: true, null: false
      t.index :text, unique: true

      t.timestamps
    end
  end
end
