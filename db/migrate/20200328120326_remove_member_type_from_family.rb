class RemoveMemberTypeFromFamily < ActiveRecord::Migration[6.0]
  def change

    remove_column :families, :member_type, :integer
    remove_column :families, :owner, :integer
  end
end
