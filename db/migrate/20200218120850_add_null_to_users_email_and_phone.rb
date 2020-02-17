# frozen_string_literal: true

# This migration fix problem, when two users cant be created,
# because empty string is not unique
class AddNullToUsersEmailAndPhone < ActiveRecord::Migration[6.0]
  def change
    # Allow null for email and phone
    change_column_null :users, :email, true
    change_column_null :users, :phone, true

    # Remove default value(was empty string) for email and phone
    change_column_default(:users, :email, nil)
    change_column_default(:users, :phone, nil)
  end
end
