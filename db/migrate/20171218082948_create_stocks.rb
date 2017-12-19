class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.integer :item_id, null: false
      t.integer :avg_unit_cost, null: false
      t.integer :current_stock, null: false
      t.timestamps
    end
  end
end
