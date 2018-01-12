require "csv"

CSV.foreach('db/Sub-categories-Sub-categories.csv') do |row|
      SubCategory.create(:category_id => row[0], :name => row[1])
    end

CSV.foreach('db/Categories-Categories.csv') do |row|
      Category.create(:name => row[0], :description => row[1])
    end

CSV.foreach('db/Stocks-Stocks.csv') do |row|
      Stock.create(name: row[0], image: row[1], detail: row[2], maker: row[3], avg_unit_cost: row[4], current_stock: row[5], sell_price: row[6], shipping_cost: row[7], category_id: row[10], sub_category_id: row[11])
    end

CSV.foreach('db/Items-Items.csv') do |row|
      Item.create(stock_id: row[0], name: row[1], image: row[2], detail: row[3], maker: row[4], unit_cost: row[5], quantity: row[6], sell_price: row[7], shipping_cost: row[8], item_flg: row[9], category_id: row[10], sub_category_id: row[11])
    end
