module StocksHelper

  def amazoncreditcard(sell_price)
    discount = sell_price - 5000
    if discount > 0
      return discount
    else
      return 0
    end
  end

end
