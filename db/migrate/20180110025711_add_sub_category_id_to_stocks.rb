class AddSubCategoryIdToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :sub_category_id, :integer
  end
end
