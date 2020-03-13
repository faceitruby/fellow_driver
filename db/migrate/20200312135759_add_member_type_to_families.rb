class AddMemberTypeToFamilies < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE member_type AS ENUM ('mother', 'father', 'son', 'daughter');
    SQL

    add_column :families, :member_type, :member_type
  end

  def down
    remove_column :families, :member_type

    execute <<-SQL
      DROP TYPE member_type;
    SQL
  end
end
