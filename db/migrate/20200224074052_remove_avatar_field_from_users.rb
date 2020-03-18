# frozen_string_literal: true

# Avatar field is not needed for User and with Active Storage
# leads to error SystemStackError (stack level too deep) on registration#create
class RemoveAvatarFieldFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :avatar, :string
  end
end
