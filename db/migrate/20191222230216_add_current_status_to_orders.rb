class AddCurrentStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :current_status, :int, default: 0
  end
end
