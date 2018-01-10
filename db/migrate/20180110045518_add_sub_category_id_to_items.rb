class AddSubCategoryIdToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :sub_category_id, :integer
  end
end
