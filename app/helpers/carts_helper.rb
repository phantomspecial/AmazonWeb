module CartsHelper
	# 数量セレクトボックスの配列作成
  def quantity_array_maker(stock)
    @current_stock_array = []
    stock.current_stock.times do |current_stock|
      if current_stock < 10
        @current_stock_array << [current_stock + 1,current_stock + 1]
      else
        break
      end
    end
    return @current_stock_array
  end

  def quantityselecter(cart)
    return cart.quantity - 1
  end
end
