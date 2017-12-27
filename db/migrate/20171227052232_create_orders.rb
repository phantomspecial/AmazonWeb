class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :user_id, foreign_key: true
      t.integer :total
      t.integer :total_shippingcost
      t.string :payments
      t.string :status
      t.timestamps
    end
  end
end
