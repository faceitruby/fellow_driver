class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :payment_type
      t.string :user_payment

      t.timestamps
    end
  end
end
