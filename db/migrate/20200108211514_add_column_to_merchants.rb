class AddColumnToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :able?, :boolean, default: true
  end
end
