class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.belongs_to :user
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :birth_day
      t.string :relationship

      t.timestamps
    end
  end
end
