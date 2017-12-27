class CreateOrderdetails < ActiveRecord::Migration[5.0]
  def change
    create_table :orderdetails do |t|
      t.integer :order_id, foreign_key: true
      t.integer :stock_id, foreign_key: true
      t.integer :quantity
      t.integer :sell_price
      t.integer :shipping_cost
      t.integer :total_price
      t.integer :total_shippingcost
      t.timestamps
    end
  end
end
