module StocksHelper

  def amazoncreditcard(sell_price)
    if sell_price > 5000
      return sell_price - 5000
    else
      return 5000 - sell_price
    end
  end

end
