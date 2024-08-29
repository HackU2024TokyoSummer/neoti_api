class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.string :customer_fincode_id, comment: 'fincodeのcustomer_idを保存しておく'
      t.references :user_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
