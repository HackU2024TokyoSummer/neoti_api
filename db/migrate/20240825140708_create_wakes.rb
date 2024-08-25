class CreateWakes < ActiveRecord::Migration[7.2]
  def change
    create_table :wakes do |t|
      t.datetime :wake_time
      t.boolean :neoti, default: false, comment: '寝落ちしたかどうか'
      t.boolean :waked, default: false, comment: '起きれたかどうか'
      t.references :user, foreign_key: true
      t.integer :billing

      t.timestamps
    end
  end
end
