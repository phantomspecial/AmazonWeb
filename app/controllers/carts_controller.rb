class CartsController < ApplicationController

# stockのshowからカートに追加した際の処理
  def index
    # @cart = Cart.stocks.find(params[:id])
    @carts = current_user.carts.all
    @cart = current_user.carts.new

    # 合計点数と合計金額の表示
    @totalitems = 0
    @totalyen = 0
    @carts.each do |cart|
      @totalitems += cart.quantity
      @totalyen += cart.quantity * Stock.find(cart.stock_id).sell_price
    end
  end

  def create
    @carts = current_user.carts.all
    update_flg = 0
    @carts.each do |cartitem|
      if cartitem.stock_id == cart_params[:stock_id].to_i
        new_quantity = cartitem.quantity + cart_params[:quantity].to_i
        cartitem.update(quantity: new_quantity)
        update_flg = 1
      end
    end
    if update_flg == 0
      @cart = current_user.carts.new(cart_params)
      @cart.save
    end

  end

  def destroy

  end

  def edit
    @cart = Cart.find(params[:id])
  end

  def update
    binding.pry
    cart = Cart.find(params[:id])
    cart.update(cart_params)
  end

  private
  def cart_params
    params.require(:cart).permit(:quantity, :stock_id)
  end

end
