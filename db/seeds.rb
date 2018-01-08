require "csv"

CSV.foreach('db/Sub-categories-Sub-categories.csv') do |row|
      SubCategory.create(:category_id => row[0], :name => row[1])
    end

CSV.foreach('db/Categories-Categories.csv') do |row|
      Category.create(:name => row[0], :description => row[1])
    end
