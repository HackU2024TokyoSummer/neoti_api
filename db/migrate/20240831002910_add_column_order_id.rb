class AddColumnOrderId < ActiveRecord::Migration[7.2]
  def change
    add_column :wakes, :order_id,:string
  end
end
