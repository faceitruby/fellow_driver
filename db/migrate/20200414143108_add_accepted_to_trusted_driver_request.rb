class AddAcceptedToTrustedDriverRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :trusted_driver_requests, :accepted, :boolean, default: false
  end
end
