module StocksHelper

  def amazoncreditcard(sell_price)
    if sell_price > 5000
      return sell_price - 5000
    else
      return 5000 - sell_price
    end
  end

  def review_rate_calc(stock)
    case stock
      when nil
        return "00"
      when ("0.0".."0.9")
        return "05"
      when ("1.0".."1.4")
        return "10"
      when ("1.5".."1.9")
        return "15"
      when ("2.0".."2.4")
        return "20"
      when ("2.5".."2.9")
        return "25"
      when ("3.0".."3.4")
        return "30"
      when ("3.5".."3.9")
        return "35"
      when ("4.0".."4.4")
        return "40"
      else
        return "50"
    end
  end

end
