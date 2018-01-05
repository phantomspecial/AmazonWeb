module ApplicationHelper
  # カートの数を取得
  def gets_cart_number
    @carts = current_user.carts.all
    @totalitems = 0
    @carts.each do |cart|
      @totalitems += cart.quantity
    end
  end
end
