class CreateFavouriteLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :favourite_locations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :address
      t.text :description

      t.timestamps
    end
  end
end
