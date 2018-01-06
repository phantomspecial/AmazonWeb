class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.string  :name, null: false
      t.string  :image, null: false
      t.string  :detail, null: false
      t.string  :maker, null: false
      t.integer :avg_unit_cost, null: false
      t.integer :current_stock, null: false
      t.integer :sell_price, null: false
      t.integer :shipping_cost, null: false
      t.timestamps
    end
  end
end
