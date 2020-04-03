class AddMemberTypeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :member_type, :integer
  end
end
