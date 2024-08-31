class AddColumnToWakes < ActiveRecord::Migration[7.2]
  def change
    add_column :wakes, :access_id, :string
  end
end
