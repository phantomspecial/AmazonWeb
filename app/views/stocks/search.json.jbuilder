json.stocks @stocks do |stock|
  json.id stock.id
  json.name stock.name
  json.image stock.image
  json.detail stock.detail
  json.maker stock.maker
  json.current_stock stock.current_stock
  json.sell_price stock.sell_price
  json.category_id stock.category_id
  json.reviews_count stock.reviews.count
  json.reviews_stars stock.avg_review
end
