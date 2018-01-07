class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :stock, foreign_key: true
      t.string  :name, null: false
      t.string  :image, null: false
      t.string  :detail, null: false
      t.string  :maker, null: false
      t.integer :unit_cost, null: false
      t.integer :quantity, null: false
      t.integer :sell_price, null: false
      t.integer :shipping_cost, null: false
      t.integer :item_flg
      t.timestamps
    end
  end
end
