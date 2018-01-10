class AddCategoryIdToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :category_id, :string
  end
end
