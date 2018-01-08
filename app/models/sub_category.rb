class SubCategory < ApplicationRecord
  belongs_to :category, optional: true

  def self.import(file)
    CSV.foreach('db/Sub-categories-Sub-categories.csv') do |row|
      SubCategory.create(:category_id => row[0], :name => row[1])
      SubCategory.save! row.to_hash
    end
  end
end
