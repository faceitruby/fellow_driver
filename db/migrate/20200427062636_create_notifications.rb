class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.string :notification_type
      t.string :subject
      t.boolean :status

      t.timestamps
    end
  end
end
