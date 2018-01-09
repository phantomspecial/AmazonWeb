class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.references :stock, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.integer :rate, null: false
      t.text :review, null: false
      t.timestamps
    end
  end
end
